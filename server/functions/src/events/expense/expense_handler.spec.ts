/// <reference types="@types/jest"/>

import { GameEntity } from '../../models/domain/game/game';
import { stubs, utils } from './expense_handler.spec.utils';
import produce from 'immer';
import { ExpenseHandler } from './expense_handler';
import { InsuranceAsset } from '../../models/domain/assets/insurance_asset';

describe('Expense event handler', () => {
  const { userId, game, initialCash } = stubs;

  beforeEach(() => {
    GameEntity.validate(game);
  });

  test('Successfully get expense', async () => {
    const handler = new ExpenseHandler();

    const event = utils.expenseEvent({
      expense: 1100,
      insuranceType: null,
    });

    const action = utils.expensePlayerAction({
      accepted: true,
    });

    const newGame = await handler.handle(game, event, action, userId);

    const expectedGame = produce(game, (draft) => {
      const participant = draft.participants[userId];
      participant.account.cash = initialCash - 1100;
    });

    expect(newGame).toStrictEqual(expectedGame);
  });

  test('Successfully get expense with health insurance', async () => {
    const handler = new ExpenseHandler();

    const event = utils.expenseEvent({
      expense: 1100,
      insuranceType: 'health',
    });

    const action = utils.expensePlayerAction({
      accepted: true,
    });

    const newGame = await handler.handle(game, event, action, userId);

    const expectedGame = produce(game, (draft) => {
      const participant = draft.participants[userId];
      participant.account.cash = initialCash - 1100;
    });

    expect(newGame).toStrictEqual(expectedGame);
  });

  test('Successfully get expense with property insurance', async () => {
    const handler = new ExpenseHandler();

    const event = utils.expenseEvent({
      expense: 1100,
      insuranceType: 'property',
    });

    const action = utils.expensePlayerAction({
      accepted: true,
    });

    const newGame = await handler.handle(game, event, action, userId);

    const expectedGame = produce(game, (draft) => {
      const participant = draft.participants[userId];
      participant.account.cash = initialCash - 0;
    });

    expect(newGame).toStrictEqual(expectedGame);
  });

  test('Successfully get expense with more than property insurance', async () => {
    const handler = new ExpenseHandler();

    const event = utils.expenseEvent({
      expense: 6100,
      insuranceType: 'property',
    });

    const action = utils.expensePlayerAction({
      accepted: true,
    });

    const newGame = await handler.handle(game, event, action, userId);

    const expectedGame = produce(game, (draft) => {
      const participant = draft.participants[userId];
      participant.account.cash = initialCash - 1100;
    });

    expect(newGame).toStrictEqual(expectedGame);
  });

  test('Successfully get expense with 2 property insurance', async () => {
    const handler = new ExpenseHandler();

    const event = utils.expenseEvent({
      expense: 7200,
      insuranceType: 'property',
    });

    const action = utils.expensePlayerAction({
      accepted: true,
    });

    const secondPropertyInsurance: InsuranceAsset = {
      id: 'insurance2',
      name: 'Страховка квартиры',
      type: 'insurance',
      value: 1_000,
      cost: 6_000,
      duration: 12,
      fromMonth: 1,
      insuranceType: 'property',
    };

    const gameWithTwoInsurances = produce(game, (draft) => {
      const participant = draft.participants[userId];
      participant.possessions.assets.push(secondPropertyInsurance);
    });

    const newGame = await handler.handle(gameWithTwoInsurances, event, action, userId);

    const expectedGame = produce(gameWithTwoInsurances, (draft) => {
      const participant = draft.participants[userId];
      participant.account.cash = initialCash - 1200;
    });

    expect(newGame).toStrictEqual(expectedGame);
  });
});
