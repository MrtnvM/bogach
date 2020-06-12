import { Game } from '../models/domain/game/game';
import { GameTransformer } from './game/game_transformer';
export { ParticipantAccountsTransformer } from './game/participant_accounts_transformer';
export { WinnersTransformer } from './game/winners_transformer';
export { MonthTransformer } from './game/month_transformer';
export { PossessionStateTransformer } from './game/possession_state_transformer';
export { GameEventsTransformer } from './game/game_events_transformer';
export { UserProgressTransformer } from './game/user_progress_transformer';
export { MonthResultTransformer } from './game/month_result_transformer';

export const applyGameTransformers = (game: Game, transformers: GameTransformer[]) => {
  return (transformers || []).reduce((prev, transformer) => transformer.apply(prev), game);
};
