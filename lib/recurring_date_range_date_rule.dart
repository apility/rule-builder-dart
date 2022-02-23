part of 'date_rule.dart';

enum RecurringDateRangeInverval { monthly, yearly }

abstract class RecurringDateRangeDateRule extends DateRule {
  RecurringDateRangeInverval get interval;

  RecurringDateRangeDateRule([String? id, String? name]) : super(id, name);

  factory RecurringDateRangeDateRule.fromInterval(
      RecurringDateRangeInverval interval, DateTime from, DateTime to,
      [String? id, String? name]) {
    switch (interval) {
      case RecurringDateRangeInverval.yearly:
        return _YearlyDateRangeRule(from, to, id, name);
      case RecurringDateRangeInverval.monthly:
        return _MonthlyDateRangeRule(from, to, id, name);
    }
  }
  factory RecurringDateRangeDateRule.parse(Map<String, dynamic> data) {
    var from = DateTime.parse(data['from'] ?? "");
    var to = DateTime.parse(data['to'] ?? "");

    switch (data['interval']) {
      case 'monthly':
        return _MonthlyDateRangeRule(from, to, data['id'], data['name']);
      case 'yearly':
        return _YearlyDateRangeRule(from, to, data['id'], data['name']);
      default:
        throw InvalidFormatExcepetion(
            "Interval can be '${data['interval'] ?? 'null'}', must be 'yearly' or 'monthly'");
    }
  }
}

class _YearlyDateRangeRule extends RecurringDateRangeDateRule {
  final DateTime from;
  final DateTime to;

  _YearlyDateRangeRule(this.from, this.to, [String? id, String? name])
      : super(
          id,
          name,
        );

  @override
  bool validate(DateTime time) {
    var from = this.from;
    var to = this.to;

    var addYear = (time.difference(to).inHours / 8766).floor();

    from = DateTime(from.year + addYear, from.month, from.day);
    to = DateTime(to.year + addYear, to.month, to.day);

    while (to.isBefore(time)) {
      from = DateTime(from.year + 1, from.month, from.day);
      to = DateTime(to.year + 1, to.month, to.day);
    }

    if (time.isBefore(from)) {
      return false;
    }

    if (time.isAfter(to) || to.isAtSameMomentAs(time)) {
      return false;
    }

    return true;
  }

  @override
  RecurringDateRangeInverval get interval => RecurringDateRangeInverval.yearly;
}

class _MonthlyDateRangeRule extends RecurringDateRangeDateRule {
  final int from;
  final int to;

  _MonthlyDateRangeRule(DateTime from, DateTime to, [String? id, String? name])
      : from = from.day,
        to = to.day,
        super(id, name);

  @override
  RecurringDateRangeInverval get interval => RecurringDateRangeInverval.monthly;

  @override
  bool validate(DateTime time) {
    final int date = time.day;
    return from > to ? !(date >= to && date < from) : date >= from && date < to;
  }
}
