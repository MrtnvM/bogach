import { Game, GameEntity } from '../../models/domain/game/game';
import { createParticipantsGameState } from '../../models/domain/game/participant_game_state';
import { PossessionsEntity } from '../../models/domain/possessions';
import { PossessionStateEntity } from '../../models/domain/possession_state';

export namespace GameFixture {
  export const createGame = (game: Partial<Game> | undefined = undefined): Game => {
    const participants = game?.participants || [];
    const defaultInitialCash = 20_000;

    const newGame: Game = {
      id: game?.id || 'game1',
      name: game?.name || 'Game 1',
      type: game?.type || 'singleplayer',
      participants: game?.participants || [],
      state: game?.state || {
        gameStatus: 'players_move',
        monthNumber: 1,
        participantProgress: createParticipantsGameState(participants, 0),
        participantsProgress: createParticipantsGameState<GameEntity.ParticipantProgress>(
          participants,
          {
            currentEventIndex: 0,
            status: 'player_move',
            monthResults: { [0]: { cash: defaultInitialCash } },
          }
        ),
        winners: {},
      },
      possessions:
        game?.possessions ||
        createParticipantsGameState(participants, PossessionsEntity.createEmpty()),
      possessionState:
        game?.possessionState ||
        createParticipantsGameState(participants, PossessionStateEntity.createEmpty()),
      accounts:
        game?.accounts ||
        createParticipantsGameState(participants, {
          cashFlow: 10_000,
          cash: defaultInitialCash,
          credit: 0,
        }),
      target: game?.target || { type: 'cash', value: 1_000_000 },
      currentEvents: game?.currentEvents || [],
    };

    GameEntity.validate(newGame);
    return newGame;
  };
}
