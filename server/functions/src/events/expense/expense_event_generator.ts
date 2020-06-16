import * as uuid from 'uuid';
import { ExpenseEvent } from './expense_event';
import * as random from 'random';
import { InsuranceAssetEntity } from '../../models/domain/assets/insurance_asset';

export namespace ExpenseEventGenerator {
  interface ExpenseEventInfo {
    readonly name;
    readonly description;
    readonly insuranceType: InsuranceAssetEntity.InsuranceType | null;
  }

  export const generate = (): ExpenseEvent.Event => {
    const expense = 1000;
    const eventCanBeCoveredByInsurance = canBeCoveredByInsurance();
    let expenseEventInfo;
    if (eventCanBeCoveredByInsurance) {
      expenseEventInfo = generateExpenseInfoWithInsurance();
    } else {
      expenseEventInfo = generateExpenseInfoWithoutInsurance();
    }

    return {
      id: uuid.v4(),
      name: expenseEventInfo.name,
      description: expenseEventInfo.description,
      type: ExpenseEvent.Type,
      data: {
        expense,
        insuranceType: expenseEventInfo.insuranceType,
      },
    };
  };

  const canBeCoveredByInsurance = (): boolean => {
    const randomInt = random.int(0, 100);
    return randomInt >= 50;
  };

  const generateExpenseInfoWithoutInsurance = (): ExpenseEventInfo => {
    const expenseTypeInfo: ExpenseEventInfo = {
      name: 'Неожиданно потеряли деньги',
      description: 'Что-то произошло',
      insuranceType: null,
    };
    return expenseTypeInfo;
  };

  const generateExpenseInfoWithInsurance = (): ExpenseEventInfo => {
    const randomInt = random.int(0, 100);

    if (randomInt > 50) {
      return generateHealthExpenseInfo();
    } else {
      return generatePropertyExpenseInfo();
    }
  };

  const generateHealthExpenseInfo = (): ExpenseEventInfo => {
    const expenseTypeInfo: ExpenseEventInfo = {
      name: 'Проблемы со здоровьем',
      description: 'Вы посетили больницу',
      insuranceType: 'health',
    };
    return expenseTypeInfo;
  };

  const generatePropertyExpenseInfo = (): ExpenseEventInfo => {
    const expenseTypeInfo: ExpenseEventInfo = {
      name: 'Проблемы с имуществом',
      description: 'Срочно нужны деньги на новый холодильник',
      insuranceType: 'property',
    };
    return expenseTypeInfo;
  };
}
