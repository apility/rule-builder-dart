part of 'date_rule.dart';

class NotRule extends DateRule {
  final DateRule child;

  NotRule({
    String? id,
    String? name,
    required this.child,
  }) : super(id, name);

  factory NotRule.parse(Map<String, dynamic> data) {
    return NotRule(
        id: data['id'],
        name: data['name'],
        child: DateRule.parse(data['child'] ?? {"type": "no"}));
  }

  @override
  bool validate(DateTime time) {
    return !child.validate(time);
  }
}
