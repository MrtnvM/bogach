
import 'package:cash_flow/resources/strings.dart';

class FormatResult {
  FormatResult(this.function, this.errorText);

  bool Function(String) function;
  String errorText;
}

bool validateEmpty(String string) => string == null || string.isEmpty;

final ruleNotEmpty = FormatResult(validateEmpty, Strings.fieldIsRequired);

String validate(String value, List<FormatResult> validators) {
  for (var item in validators) {
    if (item.function(value)) {
      return item.errorText;
    }
  }

  return null;
}
