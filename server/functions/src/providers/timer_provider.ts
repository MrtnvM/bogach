import { scheduleMonthEndTimer } from '../api/external/timer';
import { GameEntity } from '../models/domain/game/game';

export class TimerProvider {
  scheduleTimer(params: { startDateInUTC: string; gameId: GameEntity.Id; monthNumber: number }) {
    const { startDateInUTC, gameId, monthNumber } = params;

    if (!startDateInUTC || !gameId || !monthNumber) {
      throw new Error('[Schedule Timer] Invalid params: ' + JSON.stringify(params));
    }

    scheduleMonthEndTimer({
      startDateInUTC,
      gameId,
      monthNumber,
    }).catch((error) => console.error(error));
  }
}
