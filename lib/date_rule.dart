import 'package:uuid/uuid.dart';

part 'date_range_rule.dart';
part 'day_of_week_date_rule.dart';
part 'exceptions.dart';
part 'group_date_rule.dart';
part 'not_rule.dart';
part 'recurring_date_range_date_rule.dart';
part 'static_rules.dart';

abstract class DateRule {
  final String id;
  final String? name;

  DateRule(String? id, this.name) : id = id ?? Uuid().v4();

  factory DateRule.parse(Map<String, dynamic> data) {
    switch (data['type']) {
      case 'not':
        return NotRule.parse(data);
      case 'yes':
        return AlwaysTrueRule();
      case 'no':
        return AlwaysFalseRule();
      case 'group':
        return GroupDateRule.parse(data);
      case 'recurringDateRange':
        return RecurringDateRangeDateRule.parse(data);
      case 'dateRange':
        return DateRangeRule.parse(data);
      case 'dayOfWeek':
        return DayOfWeekDateRule.parse(data);
      default:
        return _InvalidNode();
    }
  }

  bool validate(DateTime time);
}

class _InvalidNode extends DateRule {
  _InvalidNode([String? id, String? name]) : super(id, name);

  @override
  bool validate(DateTime time) => false;
}
