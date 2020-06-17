import { GameTransformer } from './game_transformer';
import { Game } from '../../models/domain/game/game';
import { UserEntity } from '../../models/domain/user';
import { InsuranceAsset } from '../../models/domain/assets/insurance_asset';
import produce from 'immer';

export class InsuranceTransformer extends GameTransformer {
  constructor(private userId: UserEntity.Id) {
    super();
  }

  apply(game: Game): Game {
    const userPossessions = game.possessions[this.userId];
    const insurances = userPossessions.assets
      .filter((asset) => asset.type === 'insurance')
      .map((asset) => asset as InsuranceAsset);

    const expiredInsurances = insurances.filter((insurance) => {
      const currentMonth = game.state.participantsProgress[this.userId].currentMonthForParticipant;
      return currentMonth - insurance.fromMonth > insurance.duration;
    });

    if (expiredInsurances.length === 0) {
      return game;
    }

    const newGame = produce(game, (draft) => {
      expiredInsurances.map((expiredInsurance) => {
        console.log('expiredInsurance: ' + expiredInsurance);
        const assets = draft.possessions[this.userId].assets;
        const index = assets.findIndex((asset) => asset.id === expiredInsurance.id);

        if (index !== -1) {
          assets.splice(index, 1);
        }
      });
    });
    return newGame;
  }
}
