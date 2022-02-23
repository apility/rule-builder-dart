part of 'date_rule.dart';

class DateRangeRule extends DateRule {
  final DateTime? from;
  final DateTime? to;

  DateRangeRule(this.from, this.to, [String? id, String? name])
      : super(id, name);

  factory DateRangeRule.parse(Map<String, dynamic> data) {
    return DateRangeRule(
      (data['from'] != null ? DateTime.parse(data['from']) : null),
      (data['to'] != null ? DateTime.parse(data['to']) : null),
      data['id'],
      data['name'],
    );
  }

  @override
  bool validate(DateTime time) {
    if (from != null && time.isBefore(from!)) {
      return false;
    }

    if (to != null && (time.isAfter(to!) || time.isAtSameMomentAs(to!))) {
      return false;
    }
    return true;
  }
}
