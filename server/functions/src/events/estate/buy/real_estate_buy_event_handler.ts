import produce from 'immer';
import { Asset, AssetEntity } from '../../../models/domain/asset';
import { Liability, LiabilityEntity } from '../../../models/domain/liability';
import { PlayerActionHandler } from '../../../core/domain/player_action_handler';
import { Game } from '../../../models/domain/game/game';
import { Account } from '../../../models/domain/account';
import { UserEntity } from '../../../models/domain/user/user';
import { RealEstateBuyEvent } from './real_estate_buy_event';
import { RealtyAsset } from '../../../models/domain/assets/realty_asset';
import { DomainErrors } from '../../../core/exceptions/domain/domain_errors';

type Event = RealEstateBuyEvent.Event;
type Action = RealEstateBuyEvent.PlayerAction;

interface ActionResult {
  readonly newAccountBalance: number;
  readonly newCreditValue: number;
  readonly newAssets: Asset[];
  readonly newLiabilities: Liability[];
}

interface ActionBuyParameters {
  readonly realEstateId: string;
  readonly userAccount: Account;
  readonly assets: Asset[];
  readonly liabilities: Liability[];
  readonly currentPrice: number;
  readonly priceToPay: number;
  readonly fairPrice: number;
  readonly downPayment: number;
  readonly realtyName: string;
  readonly passiveIncomePerMonth: number;
  readonly payback: number;
  readonly sellProbability: number;
  readonly debt: number;
}

export class RealEstateBuyEventHandler extends PlayerActionHandler {
  get gameEventType(): string {
    return RealEstateBuyEvent.Type;
  }

  async validate(event: any, action: any): Promise<boolean> {
    try {
      RealEstateBuyEvent.validate(event);
      RealEstateBuyEvent.validateAction(action);
    } catch (error) {
      console.error(error);
      return false;
    }

    return true;
  }

  async handle(game: Game, event: Event, action: Action, userId: UserEntity.Id): Promise<Game> {
    const {
      realEstateId,
      currentPrice,
      fairPrice,
      downPayment,
      debt,
      passiveIncomePerMonth,
      payback,
      sellProbability,
      assetName,
    } = event.data;

    const assets = game.participants[userId].possessions.assets;
    this.checkExistingRealEstates(assets, realEstateId);

    const liabilities = game.participants[userId].possessions.liabilities;
    this.checkExistingLiability(liabilities, realEstateId);

    const userAccount = game.participants[userId].account;
    const priceToPay = currentPrice - debt;
    const realtyName = assetName;
    const actionBuyParameters: ActionBuyParameters = {
      realEstateId,
      userAccount,
      assets,
      liabilities,
      currentPrice,
      priceToPay,
      fairPrice,
      downPayment,
      realtyName: realtyName,
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

  checkExistingRealEstates(assets: Asset[], realEstateId: string) {
    const realEstatesAssets = AssetEntity.getRealties(assets);
    const theSameRealEstateIndex = realEstatesAssets.findIndex((d) => {
      return d.id === realEstateId;
    });

    if (theSameRealEstateIndex >= 0) {
      throw new Error('Can not buy two the same real estates');
    }
  }

  checkExistingLiability(liabilities: Liability[], realEstateId: string) {
    const realEstatesLiabilities = LiabilityEntity.getRealEstatesCredits(liabilities);
    const theSameLiabilityIndex = realEstatesLiabilities.findIndex((d) => {
      return d.id === realEstateId;
    });

    if (theSameLiabilityIndex >= 0) {
      throw new Error('Can not buy real estates with two the same liabilities');
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
        'Unexpected behavior on ' + RealEstateBuyEventHandler.name + 'when counting sum'
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
      realEstateId,
      assets,
      currentPrice,
      fairPrice,
      downPayment,
      realtyName,
      passiveIncomePerMonth,
      payback,
      sellProbability,
    } = actionBuyParameters;

    const newAssets = (assets || []).slice();

    const newBusiness: RealtyAsset = {
      id: realEstateId,
      buyPrice: currentPrice,
      downPayment,
      fairPrice,
      passiveIncomePerMonth,
      payback,
      sellProbability,
      name: realtyName,
      type: 'realty',
    };

    newAssets.push(newBusiness);

    return newAssets;
  }

  addNewLiability(actionBuyParameters: ActionBuyParameters): Liability[] {
    const { liabilities, realEstateId, realtyName: businessName, debt } = actionBuyParameters;

    const newLiabilities = (liabilities || []).slice();

    const newLiability: Liability = {
      id: realEstateId,
      name: businessName,
      type: 'real_estate_credit',
      monthlyPayment: 0,
      value: debt,
    };

    newLiabilities.push(newLiability);

    return newLiabilities;
  }
}
