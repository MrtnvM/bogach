import { PlayerActionHandler } from '../../core/domain/player_action_handler';
import { AssetEntity, Asset } from '../../models/domain/asset';
import { GameContext } from '../../models/domain/game/game_context';
import { GameProvider } from '../../providers/game_provider';
import { Game } from '../../models/domain/game/game';
import { Account } from '../../models/domain/account';
import produce from 'immer';
import { BusinessOfferEvent } from './business_offer_event';
import { BusinessAsset } from '../../models/domain/assets/business_asset';
import { LiabilityEntity, Liability } from '../../models/domain/liability';

type Event = BusinessOfferEvent.Event;
type Action = BusinessOfferEvent.PlayerAction;

interface ActionResult {
  readonly newAccountBalance: number;
  readonly newUserCreditValue: number;
  readonly newAssets: Asset[];
  readonly newLiabilities: Liability[];
}

interface ActionBuyParameters {
  readonly userAccount: Account;
  readonly assets: Asset[];
  readonly liabilities: Liability[];
  readonly currentPrice: number;
  readonly fairPrice: number;
  readonly downPayment: number;
  readonly businessName: string;
  readonly passiveIncomePerMonth: number;
  readonly payback: number;
  readonly sellProbability: number;
  readonly theSameBusinessIndex: number;
  readonly theSameLiabilityIndex: number;
  readonly debt: number;
}

interface ActionSellParameters {
  readonly userAccount: Account;
  readonly assets: Asset[];
  readonly theSameBusinessIndex: number;
  readonly liabilities: Liability[];
  readonly theSameLiabilityIndex: number;
  readonly currentPrice: number;
}

interface RemoveLiabilityResult {
  readonly newLiabilities: Liability[];
  readonly newUserCreditValue: number;
  readonly newAccountBalance: number;
}

export class BusinessOfferEventHandler extends PlayerActionHandler {
  constructor(private gameProvider: GameProvider) {
    super();
  }

  get gameEventType(): string {
    return BusinessOfferEvent.Type;
  }

  async validate(event: any, action: any): Promise<boolean> {
    try {
      BusinessOfferEvent.validate(event);
      BusinessOfferEvent.validateAction(action);
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
      currentPrice,
      fairPrice,
      downPayment,
      debt,
      passiveIncomePerMonth,
      payback,
      sellProbability,
    } = event.data;

    const { action: businessAction } = action;

    const businessName = event.name;

    const assets = game.possessions[userId].assets;
    const businessAssets = AssetEntity.getBusinesses(assets);
    const theSameBusinessIndex = businessAssets.findIndex((d) => {
      return d.name === businessName && d.fairPrice === fairPrice;
    });

    const liabilities = game.possessions[userId].liabilities;
    const businessLiabilities = LiabilityEntity.getBusinessCredits(liabilities);
    const theSameLiabilityIndex = businessLiabilities.findIndex((d) => {
      return d.name === businessName && d.value === debt;
    });

    const userAccount = game.accounts[userId];

    let actionResult: ActionResult;
    if (businessAction === 'buy') {
      const actionBuyParameters: ActionBuyParameters = {
        userAccount,
        assets,
        liabilities,
        currentPrice,
        fairPrice,
        downPayment,
        businessName,
        passiveIncomePerMonth,
        payback,
        sellProbability,
        theSameBusinessIndex,
        theSameLiabilityIndex,
        debt,
      };

      actionResult = await this.applyBuyAction(actionBuyParameters);
    } else if (businessAction === 'sell') {
      const actionSellParameters: ActionSellParameters = {
        userAccount,
        assets,
        theSameBusinessIndex,
        currentPrice,
        liabilities,
        theSameLiabilityIndex,
      };

      actionResult = await this.applySellAction(actionSellParameters);
    } else {
      throw new Error('Unknown action with business');
    }

    const updatedGame: Game = produce(game, (draft) => {
      // TODO add passive debt
      draft.accounts[userId].cash = actionResult.newAccountBalance;
      draft.possessions[userId].assets = actionResult.newAssets;
      draft.possessions[userId].liabilities = actionResult.newLiabilities;
    });

    await this.gameProvider.updateGame(updatedGame);
  }

  async applyBuyAction(actionParameters: ActionBuyParameters): Promise<ActionResult> {
    const {
      userAccount,
      currentPrice,
      theSameBusinessIndex,
      theSameLiabilityIndex,
    } = actionParameters;

    if (theSameBusinessIndex >= 0) {
      throw new Error('Cant buy two the same businesses(Asset)');
    }

    if (theSameLiabilityIndex >= 0) {
      throw new Error('Cant buy two the same businesses(Liability)');
    }

    const isEnoughMoney = userAccount.cash >= currentPrice;
    if (!isEnoughMoney) {
      throw new Error('Not enough money');
    }

    const newAccountBalance = userAccount.cash - currentPrice;

    const newAssets = this.addNewItemToAssets(actionParameters);
    const newLiabilities = this.addNewLiability(actionParameters);

    const actionResult: ActionResult = {
      newAccountBalance,
      newAssets,
      newLiabilities,
      newUserCreditValue: userAccount.credit,
    };

    return actionResult;
  }

  addNewItemToAssets(actionBuyParameters: ActionBuyParameters): Asset[] {
    const {
      assets,
      currentPrice,
      fairPrice,
      downPayment,
      businessName,
      passiveIncomePerMonth,
      payback,
      sellProbability,
    } = actionBuyParameters;

    let newAssets = assets.slice();

    const newBusiness: BusinessAsset = {
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
    const { liabilities, businessName, debt } = actionBuyParameters;

    let newLiabilities = liabilities.slice();

    const newLiability: Liability = {
      name: businessName,
      type: 'business_credit',
      // TODO temporary maybe, 0 now
      monthlyPayment: 0,
      value: debt,
    };

    newLiabilities.push(newLiability);

    return newLiabilities;
  }

  async applySellAction(actionParameters: ActionSellParameters): Promise<ActionResult> {
    const {
      userAccount,
      assets,
      theSameBusinessIndex,
      currentPrice,
      liabilities,
      theSameLiabilityIndex,
    } = actionParameters;

    if (theSameBusinessIndex >= 0) {
      throw new Error('Business was not found on assets(Business)');
    }

    if (theSameLiabilityIndex >= 0) {
      throw new Error('Business was not found on assets(Liability)');
    }

    const newAssets = this.removeFromAssets(theSameBusinessIndex, assets);
    const removeFromLiabiltiesResult = this.removeFromLiabilties(
      theSameLiabilityIndex,
      liabilities,
      currentPrice,
      userAccount
    );

    const actionResult: ActionResult = {
      newAccountBalance: removeFromLiabiltiesResult.newAccountBalance,
      newAssets,
      newLiabilities: removeFromLiabiltiesResult.newLiabilities,
      newUserCreditValue: removeFromLiabiltiesResult.newUserCreditValue,
    };

    return actionResult;
  }

  removeFromAssets(theSameBusinessIndex: number, assets: Asset[]): Asset[] {
    if (theSameBusinessIndex < 0 || theSameBusinessIndex > assets.length - 1) {
      throw new Error('Index not valid');
    }

    let newAssets = assets.slice();
    const countItemsToRemove = 1;
    newAssets.splice(theSameBusinessIndex, countItemsToRemove);

    return newAssets;
  }

  removeFromLiabilties(
    theSameLiabilityIndex: number,
    liabilities: Liability[],
    currentPrice: number,
    userAccount: Account
  ): RemoveLiabilityResult {
    if (theSameLiabilityIndex < 0 || theSameLiabilityIndex > liabilities.length - 1) {
      throw new Error('Index not valid');
    }

    const theSameLiability = liabilities[theSameLiabilityIndex];

    let newAccountBalance; // = userAccount.cash + currentPrice;
    let newUserCreditValue;
    const difference = currentPrice - theSameLiability.value;

    if (difference >= 0) {
      newAccountBalance = userAccount.cash + currentPrice;
      newUserCreditValue = userAccount.credit;
    } else if (difference < 0 && userAccount.cash > -difference) {
      newAccountBalance = userAccount.cash - -difference;
      newUserCreditValue = userAccount.credit;
    } else {
      // user should sell and get credit
      const emptyBalance = 0;
      newAccountBalance = emptyBalance;
      const currentUserAccountCash = userAccount.cash;
      const addToCredit = -difference - currentUserAccountCash;
      newUserCreditValue = userAccount.credit + addToCredit;
    }

    let newLiabilities = liabilities.slice();
    const countItemsToRemove = 1;
    newLiabilities.splice(theSameLiabilityIndex, countItemsToRemove);

    const removeLiabilityResult: RemoveLiabilityResult = {
      newLiabilities,
      newUserCreditValue: userAccount.credit,
      newAccountBalance,
    };

    return removeLiabilityResult;
  }
  // TODO не спутай currentPrice первый взнос и цену целиком
}
