import { produce } from 'immer';

import { GameTransformer } from './game_transformer';
import { Game, GameEntity } from '../../models/domain/game/game';
import { GameRulesProvider } from '../../providers/game_rules_provider';
import { Rule } from '../../generators/generator_rule';

type History = GameEntity.History;
type HistoryMonth = GameEntity.HistoryMonth;

export class HistoryGameTransformer extends GameTransformer {
  constructor() {
    super();
  }

  transformerContext() {
    return { name: 'HistoryGameTransformer' };
  }

  apply(game: Game): Game {
    if (game.state.gameStatus === 'game_over') {
      return game;
    }

    const isMoveCompleted = this.isAllParticipantsCompletedMove(game);
    const historyMonthIndex = Math.max(game.state.monthNumber - 1, 0);

    const months = game.history?.months || [];
    const currentMonth = months[historyMonthIndex];
    const isHistoryAlreadyUpdated = currentMonth?.events && currentMonth.events.length > 0;

    const ruleProvider = new GameRulesProvider();
    const rules = ruleProvider.getRulesForGame(game);

    let history = game.history || { months: [] };

    if (isMoveCompleted && !isHistoryAlreadyUpdated) {
      history = produce(history, (draft) => {
        const historyMonth: HistoryMonth = { events: game.currentEvents || [] };
        draft.months[historyMonthIndex] = historyMonth;
      });
    }

    const updatedHistory = this.getFilteredHistoryEvents(history, rules);

    return produce(game, (draft) => {
      draft.history = updatedHistory;
    });
  }

  getFilteredHistoryEvents(history: History, rules: Rule[]): History {
    return produce(history, (draft) => {
      for (const rule of rules) {
        const maxHistoryLength = rule.getMaxHistoryLength();

        if (maxHistoryLength < 0) {
          /// The number of events that should be saved in the history
          let eventsCount = Math.abs(maxHistoryLength);

          /// Passing months in reverse order for searching last event of the type
          for (const month of [...draft.months].reverse()) {
            if (!month) {
              continue;
            }

            /// Passing month events in reverse order
            /// for searching last events of the type in the month
            for (let i = month.events.length - 1; i >= 0; i--) {
              const monthEvent = month.events[i];

              if (monthEvent.type === rule.getType()) {
                eventsCount -= 1;

                /// If we found max events count for history date
                /// then we removing the rest useless elements
                if (eventsCount < 0) {
                  month.events.splice(i, 1);
                }
              }
            }
          }
        }

        if (maxHistoryLength > 0) {
          /// If max history length of the current rule is lower than
          /// currently available history length the go to the next rule
          if (draft.months.length <= maxHistoryLength) {
            continue;
          }

          let lastMonthThatContainsEvent = -1;
          for (let monthIndex = draft.months.length - 1; monthIndex >= 0; monthIndex--) {
            const month = draft.months[monthIndex];

            if (!month) {
              continue;
            }

            for (const event of month.events) {
              if (event.type === rule.getType()) {
                lastMonthThatContainsEvent = monthIndex;
                break;
              }
            }

            if (lastMonthThatContainsEvent >= 0) {
              break;
            }
          }

          const maxHistoryIndexForClearing = lastMonthThatContainsEvent - maxHistoryLength;

          for (let monthIndex = 0; monthIndex <= maxHistoryIndexForClearing; monthIndex++) {
            const month = draft.months[monthIndex];

            if (!month) {
              continue;
            }

            for (let eventIndex = month.events.length - 1; eventIndex >= 0; eventIndex--) {
              const event = month.events[eventIndex];

              /// Removing useless month events
              if (event.type === rule.getType()) {
                month.events.splice(eventIndex, 1);
              }
            }
          }
        }
      }
    });
  }
}
