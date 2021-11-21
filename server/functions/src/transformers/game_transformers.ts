import { Game } from '../models/domain/game/game';
import { GameTransformer } from './game/game_transformer';
export { ParticipantAccountsTransformer } from './game/participant_accounts_transformer';
export { WinnersTransformer } from './game/winners_transformer';
export { MonthTransformer } from './game/month_transformer';
export { PossessionStateTransformer } from './game/possession_state_transformer';
export { GameEventsTransformer } from './game/game_events_transformer';
export { UserProgressTransformer } from './game/user_progress_transformer';
export { MonthResultTransformer } from './game/month_result_transformer';
export { StocksInitializerGameTransformer } from './game/configuration/stocks/stocks_initializer_game_transformer';
export { DebentureInitializerGameTransformer } from './game/configuration/debenture/debenture_initializer_game_transformer';
export { HistoryGameTransformer } from './game/history_game_transformer';
export { UpdateMoveStartDateTransformer } from './game/update_move_start_date_transformer';
export { StatisticsTransformer } from './game/statistics_transformer';

export const applyGameTransformers = (game: Game, transformers: GameTransformer[]) => {
  return (transformers || []).reduce((prev, transformer) => {
    try {
      return transformer.apply(prev);
    } catch (err: any) {
      const context = transformer.transformerContext();
      const errorMessage =
        'GAME TRANSFORMER ERROR\n' +
        `CONTEXT: ${JSON.stringify(context, null, 2)}\n` +
        `ERROR MESSAGE: ${err && err['message']}`;

      throw new Error(errorMessage);
    }
  }, game);
};
