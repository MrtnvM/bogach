import { stubs } from './business_sell_event_provider.spec.utils';
import { GameEntity } from '../../models/domain/game/game';
import { mock, instance, reset, when, anything } from 'ts-mockito';
import { BusinessSellEventProvider } from './business_sell_event_provider';
import { BusinessSellEventGenerator } from '../../events/business/sell/business_sell_event_generator';

describe('business sell event provider', () => {
  const { game, businessSellEvent } = stubs;
  const mockBusinessSellEventGeneratorProvider = mock(BusinessSellEventGenerator);

  beforeEach(() => {
    GameEntity.validate(game);
    reset(mockBusinessSellEventGeneratorProvider);
  });

  test('generate sell event to businesses', async () => {
    when(mockBusinessSellEventGeneratorProvider.generate(anything())).thenReturn(businessSellEvent);

    const mockBusinessSellEventGenerator = instance(mockBusinessSellEventGeneratorProvider);

    const businessSellEventProvider = new BusinessSellEventProvider(mockBusinessSellEventGenerator);
    const expectedSellBusinessEvents = [businessSellEvent, businessSellEvent];

    const actualSellBusinessEvents = businessSellEventProvider.generateBusinessSellEvent(game);
    expect(actualSellBusinessEvents).toStrictEqual(expectedSellBusinessEvents);
  });
});
