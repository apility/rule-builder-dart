part of 'date_rule.dart';

class AlwaysTrueRule extends DateRule {
  AlwaysTrueRule([String? id, String? name]) : super(id, name);

  @override
  bool validate(DateTime time) {
    return true;
  }
}

class AlwaysFalseRule extends DateRule {
  AlwaysFalseRule([String? id, String? name]) : super(id, name);

  @override
  bool validate(DateTime time) {
    return false;
  }
}
