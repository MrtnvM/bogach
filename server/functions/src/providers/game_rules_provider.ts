import { Game } from '../models/domain/game/game';
import { Rule } from '../generators/generator_rule';
import { IncomeGenerateRule } from '../generators/rules/income_generate_rule';
import { IncomeGeneratorConfig } from '../events/income/income_generator_config';
import { ExpenseGeneratorConfig } from '../events/expense/expense_generator_config';
import { InsuranceGeneratorConfig } from '../events/insurance/insurance_generator_config';
import { BusinessBuyGenerateRule } from '../generators/rules/business_buy_generate_rule';
import { BusinessSellGenerateRule } from '../generators/rules/business_sell_generate_rules';
import { DebentureGenerateRule } from '../generators/rules/debenture_generate_rule';
import { ExpenseGenerateRule } from '../generators/rules/expense_generate_rule';
import { InsuranceGenerateRule } from '../generators/rules/insurance_generate_rule';
import { MonthlyExpenseGenerateRule } from '../generators/rules/monthly_expense_generate_rule';
import { RealEstateBuyRule } from '../generators/rules/real_estate_buy_generate_rule';
import { StockGenerateRule } from '../generators/rules/stock_generate_rule';

export class GameRulesProvider {
  getRulesForGame(game: Game): Rule[] {
    const incomeRule = new IncomeGenerateRule(
      {
        probabilityLevel: 4,
        minDistanceBetweenEvents: 3,
        maxHistoryLength: 12,
        maxCountOfEventInMonth: 1,
      },
      IncomeGeneratorConfig.allIncomes
    );

    const expenseRule = new ExpenseGenerateRule(
      {
        probabilityLevel: 4,
        minDistanceBetweenEvents: 2,
        maxHistoryLength: 12,
        maxCountOfEventInMonth: 1,
      },
      ExpenseGeneratorConfig.allExpenses
    );

    const healthInsuranceRule = new InsuranceGenerateRule(
      {
        probabilityLevel: 5,
        minDistanceBetweenEvents: 6,
        maxHistoryLength: 4,
        maxCountOfEventInMonth: 1,
      },
      InsuranceGeneratorConfig.healthInsurance()
    );

    const propertyInsuranceRule = new InsuranceGenerateRule(
      {
        probabilityLevel: 5,
        minDistanceBetweenEvents: 6,
        maxHistoryLength: 4,
        maxCountOfEventInMonth: 1,
      },
      InsuranceGeneratorConfig.propertyInsurance()
    );

    const debentureRule = new DebentureGenerateRule({
      probabilityLevel: 10,
      minDistanceBetweenEvents: 0,
      maxHistoryLength: -1,
      maxCountOfEventInMonth: 1,
    });

    const monthlyExpenseRule = new MonthlyExpenseGenerateRule({
      probabilityLevel: 3,
      maxCountOfEventInMonth: 0,
      minDistanceBetweenEvents: 2,
      maxHistoryLength: 12,
    });

    const stockRule = new StockGenerateRule({
      probabilityLevel: 10,
      minDistanceBetweenEvents: 0,
      maxHistoryLength: -4,
      maxCountOfEventInMonth: 3,
    });

    const realEstateRule = new RealEstateBuyRule({
      probabilityLevel: 10,
      minDistanceBetweenEvents: 1,
      maxHistoryLength: 12,
      maxCountOfEventInMonth: 1,
    });

    const businessBuyGenerateRule = new BusinessBuyGenerateRule({
      probabilityLevel: 6,
      minDistanceBetweenEvents: 2,
      maxHistoryLength: 12,
      maxCountOfEventInMonth: 1,
    });

    const businessSellGenerateRule = new BusinessSellGenerateRule({
      probabilityLevel: 4,
      minDistanceBetweenEvents: 10,
      maxHistoryLength: 12,
      maxCountOfEventInMonth: 1,
    });

    return [
      incomeRule,
      expenseRule,
      healthInsuranceRule,
      propertyInsuranceRule,
      debentureRule,
      monthlyExpenseRule,
      stockRule,
      realEstateRule,
      businessBuyGenerateRule,
      businessSellGenerateRule,
    ];
  }
}
