import { GameEventEntity, GameEvent } from "../../models/domain/game/game_event";
import { BuySellAction, BuySellActionValues } from "../../models/domain/actions/buy_sell_action";
import { Entity } from "../../core/domain/entity";


export namespace StockPriceChangedEvent {
    export const Type: GameEventEntity.Type = 'stock-price-changed-event';

    export type Event = GameEvent<Data>;

    export interface Data {
        readonly currentPrice: number;
        readonly fairPrice: number;
        readonly portfolioCount: number;
        readonly maxCount: number;
    }

    export interface PlayerAction {
        readonly eventId: GameEventEntity.Id;
        readonly action: BuySellAction;
        readonly count: number;
    }


    export const parse = (gameEvent: GameEvent, eventData: any): Event => {
        const { currentPrice, fairPrice, portfolioCount, maxCount } = eventData.data;
 
        return {
            ...gameEvent,
            data: {
                currentPrice,
                fairPrice,
                portfolioCount,
                maxCount,
            },
        };
    };

    export const validate = (event: any) => {
        if (event?.type !== Type) {
          throw new Error('ERROR: Event type is not equal to ' + Type);
        }
    
        const entity = Entity.createEntityValidator<Data>(
          event.data,
          'StockPriceChangedEvent.Data'
        );
    
        entity.hasNumberValue('currentPrice');
        entity.hasNumberValue('fairPrice');
        entity.hasNumberValue('portfolioCount');
        entity.hasNumberValue('maxCount');
    
        entity.checkWithRules([
          [(a) => a.currentPrice <= 0, "Current price can't be <= 0"],
          [(a) => a.fairPrice <= 0, "FairPrice can't be <= 0"],
          [(a) => a.portfolioCount < 0, "PoftfolioCount can't be < 0"],
          [(a) => a.maxCount < 0, "MaxCount can't be < 0"],
        ]);
      };
    
      export const validateAction = (action: any) => {
        const entity = Entity.createEntityValidator<PlayerAction>(
          action,
          'StockPriceChangedEvent.PlayerAction'
        );
    
        entity.hasValue('eventId');
        entity.checkUnion('action', BuySellActionValues);
        entity.hasValue('count');
    
        entity.checkWithRules([[(a) => a.count <= 0, "Count can't be <= 0"]]);
      };

}