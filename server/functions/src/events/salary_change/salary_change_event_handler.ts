import produce from 'immer';
import { Game } from '../../models/domain/game/game';
import { UserEntity } from '../../models/domain/user/user';
import { SalaryChangeEvent } from './salary_change_event';
import { PlayerActionHandler } from '../../core/domain/player_action_handler';

type Event = SalaryChangeEvent.Event;
type Action = SalaryChangeEvent.PlayerAction;

export class SalaryChangeEventHandler extends PlayerActionHandler {
  get gameEventType(): string {
    return SalaryChangeEvent.Type;
  }

  async validate(event: any, action: any): Promise<boolean> {
    try {
      SalaryChangeEvent.validate(event);
      SalaryChangeEvent.validateAction(action);
    } catch (error) {
      console.error(error);
      return false;
    }

    return true;
  }

  async handle(game: Game, event: Event, action: Action, userId: UserEntity.Id): Promise<Game> {
    const { value } = event.data;

    const updatedGame: Game = produce(game, (draft) => {
      const participant = draft.participants[userId];
      const incomes = participant.possessions.incomes;
      const salaryIncomeIndex = incomes.findIndex((i) => i.type === 'salary');

      if (salaryIncomeIndex < 0) {
        return;
      }

      const salaryIncome = incomes[salaryIncomeIndex];
      salaryIncome.value += value;
    });

    return updatedGame;
  }
}
