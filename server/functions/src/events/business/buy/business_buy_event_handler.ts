import produce from 'immer';
import { BusinessBuyEvent } from './business_buy_event';
import { Asset, AssetEntity } from '../../../models/domain/asset';
import { Liability, LiabilityEntity } from '../../../models/domain/liability';
import { PlayerActionHandler } from '../../../core/domain/player_action_handler';
import { Game } from '../../../models/domain/game/game';
import { Account } from '../../../models/domain/account';
import { BusinessAsset } from '../../../models/domain/assets/business_asset';
import { UserEntity } from '../../../models/domain/user/user';
import { DomainErrors } from '../../../core/exceptions/domain/domain_errors';
import { CreditHandler } from '../../common/credit_handler';

type Event = BusinessBuyEvent.Event;
type Action = BusinessBuyEvent.PlayerAction;

interface ActionResult {
  readonly newAccountBalance: number;
  readonly newCreditValue: number;
  readonly newAssets: Asset[];
  readonly newLiabilities: Liability[];
}

interface BuyResult {
  readonly newAccountBalance: number;
  readonly newCreditValue: number;
  readonly credit?: Liability;
  readonly defaultLiability?: Liability;
}

interface ActionBuyParameters {
  readonly businessId: string;
  readonly userAccount: Account;
  readonly assets: Asset[];
  readonly liabilities: Liability[];
  readonly currentPrice: number;
  readonly priceToPay: number;
  readonly fairPrice: number;
  readonly downPayment: number;
  readonly businessName: string;
  readonly passiveIncomePerMonth: number;
  readonly payback: number;
  readonly sellProbability: number;
  readonly debt: number;
  readonly buyInCredit: boolean;
}

export class BusinessBuyEventHandler extends PlayerActionHandler {

  constructor(private creditHandler: CreditHandler) {
    super()
  }

  get gameEventType(): string {
    return BusinessBuyEvent.Type;
  }

  async validate(event: any, action: any): Promise<boolean> {
    try {
      BusinessBuyEvent.validate(event);
      BusinessBuyEvent.validateAction(action);
    } catch (error) {
      console.error(error);
      return false;
    }

    return true;
  }

  async handle(game: Game, event: Event, action: Action, userId: UserEntity.Id): Promise<Game> {

    const {
      businessId,
      currentPrice,
      fairPrice,
      downPayment,
      debt,
      passiveIncomePerMonth,
      payback,
      sellProbability,
      buyInCredit,
    } = event.data;

    const { action: businessAction } = action;

    if (businessAction !== 'buy') {
      throw new Error(
        'Error action type when dispatching ' +
          businessAction +
          ' in ' +
          BusinessBuyEventHandler.name
      );
    }

    const gameParticipant = game.participants[userId];
    const assets = gameParticipant.possessions.assets;
    this.checkExistingBusiness(assets, businessId);

    const liabilities = gameParticipant.possessions.liabilities;
    this.checkExistingLiability(liabilities, businessId);

    const userAccount = gameParticipant.account;
    const priceToPay = currentPrice - debt;
    const businessName = event.name;
    const actionBuyParameters: ActionBuyParameters = {
      businessId,
      userAccount,
      assets,
      liabilities,
      currentPrice,
      priceToPay,
      fairPrice,
      downPayment,
      businessName,
      passiveIncomePerMonth,
      payback,
      sellProbability,
      debt,
      buyInCredit,
    };

    const actionResult = this.applyBuyAction(actionBuyParameters);

    const updatedGame: Game = produce(game, (draft) => {
      const draftParticipant = draft.participants[userId];

      draftParticipant.account.credit = actionResult.newCreditValue;
      draftParticipant.account.cash = actionResult.newAccountBalance;
      draftParticipant.possessions.assets = actionResult.newAssets;
      draftParticipant.possessions.liabilities = actionResult.newLiabilities;
    });

    return updatedGame;
  }

  checkExistingBusiness(assets: Asset[], businessId: string) {
    const businessAssets = AssetEntity.getBusinesses(assets);
    const theSameBusinessIndex = businessAssets.findIndex((d) => {
      return d.id === businessId;
    });

    if (theSameBusinessIndex >= 0) {
      throw new Error('Cant buy two the same businesses');
    }
  }

  checkExistingLiability(liabilities: Liability[], businessId: string) {
    const businessLiabilities = LiabilityEntity.getBusinessCredits(liabilities);
    const theSameLiabilityIndex = businessLiabilities.findIndex((d) => {
      return d.id === businessId && d.type === 'business_credit';
    });

    if (theSameLiabilityIndex >= 0) {
      throw new Error('Cant buy business with two the same liabilities');
    }
  }

  applyBuyAction(actionParameters: ActionBuyParameters): ActionResult {
    const { buyInCredit, userAccount, priceToPay } = actionParameters;

    const isEnoughMoney = userAccount.cash >= priceToPay;
    let buyResult;
    if (!buyInCredit || isEnoughMoney) {
      buyResult = this.handleBuyWithoutCredit(actionParameters);
    } else {
      buyResult = this.handleBuyWithCredit(actionParameters);
    }

    const newAssets = this.addNewItemToAssets(actionParameters);
    var newLiabilities = this.addNewLiability(actionParameters.liabilities, buyResult.defaultLiability);
    newLiabilities = this.addNewLiability(newLiabilities, buyResult.credit);

    const actionResult: ActionResult = {
      newAccountBalance: buyResult.newAccountBalance,
      newAssets,
      newLiabilities,
      newCreditValue: buyResult.newCreditValue,
    };

    return actionResult;
  }

  addNewItemToAssets(actionBuyParameters: ActionBuyParameters): Asset[] {
    const {
      businessId,
      assets,
      currentPrice,
      fairPrice,
      downPayment,
      businessName,
      passiveIncomePerMonth,
      payback,
      sellProbability,
    } = actionBuyParameters;

    const newAssets = (assets || []).slice();

    const newBusiness: BusinessAsset = {
      id: businessId,
      buyPrice: currentPrice,
      downPayment,
      fairPrice,
      passiveIncomePerMonth,
      payback,
      sellProbability,
      name: businessName,
      type: 'business',
    };

    newAssets.push(newBusiness);

    return newAssets;
  }

  addNewLiability(liabilities: Liability[], newLiability?: Liability): Liability[] {
    if (newLiability === undefined) {
      return liabilities;
    }

    const newLiabilities = liabilities.slice();
    newLiabilities.push(newLiability);
    return newLiabilities;
  }

  handleBuyWithoutCredit(actionParameters: ActionBuyParameters): BuyResult {
    const { userAccount, priceToPay } = actionParameters;

    const isEnoughMoney = userAccount.cash >= priceToPay;
    if (!isEnoughMoney) {
      throw DomainErrors.notEnoughCash;
    }

    const defaultLiability = this.createDefaultLiability(actionParameters);

    const newAccountBalance = userAccount.cash - priceToPay;
    const buyResult: BuyResult = {
      newAccountBalance,
      newCreditValue: userAccount.credit,
      defaultLiability: defaultLiability,
    };

    return buyResult;
  }

  handleBuyWithCredit(actionParameters: ActionBuyParameters): BuyResult {
    const { businessId, businessName, userAccount, priceToPay } = actionParameters;

    const creditParameters = {
      userCashFlow: userAccount.cashFlow,
      userCash: userAccount.cash,
      priceToPay: priceToPay,
    };
    console.log(creditParameters);
    const isCreditAvailable = this.creditHandler.isCreditAvailable(creditParameters);

    console.log(isCreditAvailable);
    if (!isCreditAvailable) {
      console.log("not available")
      throw DomainErrors.creditIsNotAvilable;
    }
    console.log("available")

    const sumToCredit = priceToPay - userAccount.cash;
    const newAccountBalance = 0;
    const newCreditValue = userAccount.credit + sumToCredit;

    const monthlyPayment = Math.round(sumToCredit / 12);

    const credit: Liability = {
      id: businessId,
      name: businessName,
      type: 'credit',
      monthlyPayment: monthlyPayment,
      value: sumToCredit,
    };

    const defaultLiability = this.createDefaultLiability(actionParameters);

    const buyResult: BuyResult = {
      newAccountBalance,
      newCreditValue,
      credit,
      defaultLiability,
    };

    return buyResult;
  }

  createDefaultLiability(actionParameters: ActionBuyParameters): Liability {
    const { businessId, businessName, debt } = actionParameters;

    const liability: Liability = {
      id: businessId,
      name: businessName,
      type: 'business_credit',
      monthlyPayment: 0,
      value: debt,
    };

    return liability;
  }
}
