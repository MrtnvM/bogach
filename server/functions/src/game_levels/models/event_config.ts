import { IncomeEvent } from '../../events/income/income_event';
import { ExpenseEvent } from '../../events/expense/expense_event';
import { DebenturePriceChangedEvent } from '../../events/debenture/debenture_price_changed_event';

export interface EventConfig {
  readonly incomeEvents: IncomeEvent.Info[];
  readonly expenseEvents: ExpenseEvent.Info[];
  readonly debentureEvents: DebenturePriceChangedEvent.InfoConfig[];
}
