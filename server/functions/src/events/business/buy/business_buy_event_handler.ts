import produce from 'immer';
import { BusinessBuyEvent } from './business_buy_event_event';
import { Asset, AssetEntity } from '../../../models/domain/asset';
import { Liability, LiabilityEntity } from '../../../models/domain/liability';
import { GameContext } from '../../../models/domain/game/game_context';
import { GameProvider } from '../../../providers/game_provider';
import { PlayerActionHandler } from '../../../core/domain/player_action_handler';
import { Game } from '../../../models/domain/game/game';
import { Account } from '../../../models/domain/account';
import { BusinessAsset } from '../../../models/domain/assets/business_asset';

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
  constructor(private gameProvider: GameProvider) {
    super();
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

  async handle(event: Event, action: Action, context: GameContext): Promise<void> {
    const { gameId, userId } = context;
    const game = await this.gameProvider.getGame(gameId);

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

    const businessName = event.name;

    const assets = game.possessions[userId].assets;
    this.checkExistingBusiness(assets, businessId);

    const liabilities = game.possessions[userId].liabilities;
    this.checkExistingLiability(liabilities, businessId);

    const userAccount = game.accounts[userId];
    const priceToPay = currentPrice - debt;
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

    const actionResult = await this.applyBuyAction(actionBuyParameters);

    const updatedGame: Game = produce(game, (draft) => {
      draft.accounts[userId].credit = actionResult.newCreditValue;
      draft.accounts[userId].cash = actionResult.newAccountBalance;
      draft.possessions[userId].assets = actionResult.newAssets;
      draft.possessions[userId].liabilities = actionResult.newLiabilities;
    });

    await this.gameProvider.updateGame(updatedGame);
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
      return d.id === businessId && d.type == 'business_credit';
    });

    if (theSameLiabilityIndex >= 0) {
      throw new Error('Cant buy business with two the same liabilities');
    }
  }

  async applyBuyAction(actionParameters: ActionBuyParameters): Promise<ActionResult> {
    const { userAccount, priceToPay } = actionParameters;

    //TODO implement credit and write tests
    const canCredit = false;
    const isEnoughMoney = userAccount.cash >= priceToPay;
    if (!isEnoughMoney && !canCredit) {
      throw new Error('Not enough money');
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
        'Unexpected behaviour on ' + BusinessBuyEventHandler.name + 'when counting sum'
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

    const newAssets = assets.slice();

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

    const newLiabilities = liabilities.slice();

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
