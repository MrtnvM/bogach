import { GameTransformer } from './game_transformer';
import { Game } from '../../models/domain/game/game';
import { UserEntity } from '../../models/domain/user/user';
import { InsuranceAsset } from '../../models/domain/assets/insurance_asset';
import produce from 'immer';

export class InsuranceTransformer extends GameTransformer {
  constructor(private userId: UserEntity.Id) {
    super();
  }

  transformerContext() {
    return { name: 'InsuranceTransformer', userId: this.userId };
  }

  apply(game: Game): Game {
    const participant = game.participants[this.userId];
    const userPossessions = participant.possessions;
    const insurances = userPossessions.assets
      .filter((asset) => asset.type === 'insurance')
      .map((asset) => asset as InsuranceAsset);

    const expiredInsurances = insurances.filter((insurance) => {
      const currentMonth = participant.progress.currentMonthForParticipant;
      return currentMonth - insurance.fromMonth > insurance.duration;
    });

    if (expiredInsurances.length === 0) {
      return game;
    }

    const newGame = produce(game, (draft) => {
      expiredInsurances.map((expiredInsurance) => {
        console.log('expiredInsurance: ' + expiredInsurance);

        const assets = draft.participants[this.userId].possessions.assets;
        const index = assets.findIndex((asset) => asset.id === expiredInsurance.id);

        if (index !== -1) {
          assets.splice(index, 1);
        }
      });
    });

    return newGame;
  }
}
