part of 'date_rule.dart';

class DayOfWeekDateRule extends DateRule {
  final List<int> days;

  DayOfWeekDateRule(List<int> days, [String? id, String? name])
      : days = days.map((f) => f == 0 ? 7 : f).toList(growable: false),
        super(id, name);

  factory DayOfWeekDateRule.parse(Map<String, dynamic> data) {
    return DayOfWeekDateRule(data['days'], data['id'], data['name']);
  }

  @override
  bool validate(DateTime time) {
    return days.contains(time.weekday);
  }
}
