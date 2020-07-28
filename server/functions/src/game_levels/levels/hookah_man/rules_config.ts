import { Rule, RuleConfig } from '../../../generators/generator_rule';
import { InsuranceGenerateRule } from '../../../generators/rules/insurance_generate_rule';
import { InsuranceGeneratorConfig } from '../../../events/insurance/insurance_generator_config';
import { eventConfig } from './event_config';
import { IncomeGenerateRule } from '../../../generators/rules/income_generate_rule';
import { DebentureGenerateRule } from '../../../generators/rules/debenture_generate_rule';
import { StockGenerateRule } from '../../../generators/rules/stock_generate_rule';
import { ExpenseGenerateRule } from '../../../generators/rules/expense_generate_rule';

const getIncomeGenenerateRule = () => {
  const incomeEvents = eventConfig.incomeEvents;

  const ruleConfig: RuleConfig = {
    probabilityLevel: 4,
    minDistanceBetweenEvents: 3,
  };

  return new IncomeGenerateRule(ruleConfig, incomeEvents);
};

const getExpenseGenenerateRule = () => {
  const expenseEvents = eventConfig.expenseEvents;

  const ruleConfig: RuleConfig = {
    probabilityLevel: 4,
    minDistanceBetweenEvents: 2,
  };

  return new ExpenseGenerateRule(ruleConfig, expenseEvents);
};

const getHealthInsuranceGenerateRule = () => {
  const insuranceInfo = InsuranceGeneratorConfig.healthInsurance();

  const ruleConfig: RuleConfig = {
    probabilityLevel: 5,
    minDistanceBetweenEvents: 6,
  };

  return new InsuranceGenerateRule(ruleConfig, insuranceInfo);
};

const getPropertyInsuranceGenerateRule = () => {
  const insuranceInfo = InsuranceGeneratorConfig.propertyInsurance();

  const ruleConfig: RuleConfig = {
    probabilityLevel: 5,
    minDistanceBetweenEvents: 6,
  };

  return new InsuranceGenerateRule(ruleConfig, insuranceInfo);
};

const getDebentureRule = () => {
  return new DebentureGenerateRule();
};

const getStockRule = () => {
  return new StockGenerateRule();
};

export const rules: Rule[] = [
  getIncomeGenenerateRule(),
  getExpenseGenenerateRule(),
  getHealthInsuranceGenerateRule(),
  getPropertyInsuranceGenerateRule(),
  getDebentureRule(),
  getStockRule(),
];
