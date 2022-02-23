part of 'date_rule.dart';

abstract class DateRuleException implements Exception {
  final String message;

  DateRuleException(this.message);

  String toString() => "$runtimeType($message)";
}

class InvalidFormatExcepetion extends DateRuleException {
  InvalidFormatExcepetion(String message) : super(message);
}
