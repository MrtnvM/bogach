import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/utils/email_validator.dart';

class FormatResult {
  FormatResult(this.function, this.errorText);

  bool Function(String) function;
  String errorText;
}

bool validateEmpty(String string) => string == null || string.isEmpty;

bool validatePassword(String string) => string == null || string.length < 6;

bool validateEmail(String email) {
  if (email == null) {
    return true;
  }

  final partsSplittedByDot = email.split('.');
  final domainMoreThanTwoLetters =
      partsSplittedByDot.isNotEmpty && partsSplittedByDot.last.length >= 2;

  return !EmailValidator.validate(email) || !domainMoreThanTwoLetters;
}

final ruleNotEmpty = FormatResult(validateEmpty, Strings.fieldIsRequired);
final ruleEmail = FormatResult(validateEmail, Strings.incorrectEmail);
final rulePassword = FormatResult(validatePassword, Strings.incorrectPassword);

FormatResult rulePasswordsShouldMatch(bool Function(String) function) {
  return FormatResult(function, Strings.passwordAreDifferent);
}

String validate(String value, List<FormatResult> validators) {
  for (final item in validators) {
    if (item.function(value)) {
      return item.errorText;
    }
  }

  return null;
}
