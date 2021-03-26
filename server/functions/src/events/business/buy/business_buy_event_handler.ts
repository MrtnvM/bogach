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

type Event = BusinessBuyEvent.Event;
type Action = BusinessBuyEvent.PlayerAction;

interface ActionResult {
  readonly newAccountBalance: number;
  readonly newCreditValue: number;
  readonly newAssets: Asset[];
  readonly newLiabilities: Liability[];
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
}

export class BusinessBuyEventHandler extends PlayerActionHandler {
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

    const assets = game.participants[userId].possessions.assets;
    this.checkExistingBusiness(assets, businessId);

    const liabilities = game.participants[userId].possessions.liabilities;
    this.checkExistingLiability(liabilities, businessId);

    const userAccount = game.participants[userId].account;
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
    };

    const actionResult = this.applyBuyAction(actionBuyParameters);

    const updatedGame: Game = produce(game, (draft) => {
      const participant = draft.participants[userId];

      participant.account.credit = actionResult.newCreditValue;
      participant.account.cash = actionResult.newAccountBalance;
      participant.possessions.assets = actionResult.newAssets;
      participant.possessions.liabilities = actionResult.newLiabilities;
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
    const { userAccount, priceToPay } = actionParameters;

    //TODO implement credit and write tests
    const canCredit = false;
    const isEnoughMoney = userAccount.cash >= priceToPay;
    if (!isEnoughMoney && !canCredit) {
      throw DomainErrors.notEnoughCash;
    }

    let newAccountBalance = 0;
    let newCreditValue = userAccount.credit;
    if (priceToPay <= userAccount.cash) {
      newAccountBalance = userAccount.cash - priceToPay;
    } else if (canCredit) {
      const sumToCredit = priceToPay - userAccount.cash;
      newAccountBalance = 0;
      newCreditValue += sumToCredit;
    } else {
      throw new Error(
        'Unexpected behavior on ' + BusinessBuyEventHandler.name + 'when counting sum'
      );
    }

    const newAssets = this.addNewItemToAssets(actionParameters);
    const newLiabilities = this.addNewLiability(actionParameters);

    const actionResult: ActionResult = {
      newAccountBalance,
      newAssets,
      newLiabilities,
      newCreditValue,
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

  addNewLiability(actionBuyParameters: ActionBuyParameters): Liability[] {
    const { liabilities, businessId, businessName, debt } = actionBuyParameters;

    const newLiabilities = (liabilities || []).slice();

    const newLiability: Liability = {
      id: businessId,
      name: businessName,
      type: 'business_credit',
      // TODO temporary maybe, 0 now
      monthlyPayment: 0,
      value: debt,
    };

    newLiabilities.push(newLiability);

    return newLiabilities;
  }
}
