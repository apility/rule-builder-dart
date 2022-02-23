part of 'date_rule.dart';

enum GroupType { all, any }

abstract class GroupDateRule extends DateRule {
  List<DateRule> get children;
  GroupType get type;

  GroupDateRule([String? id, String? name]) : super(id, name);

  factory GroupDateRule.ofType(GroupType type, List<DateRule> children,
      [String? id, String? name]) {
    if (children.isEmpty) {
      return _NoChildrenRule(type, id, name);
    }

    switch (type) {
      case GroupType.all:
        return _AllGroupRule(children, id, name);
      case GroupType.any:
        return _AnyGroupRule(children, id, name);
    }
  }

  factory GroupDateRule.parse(Map<String, dynamic> data) {
    GroupType type = GroupType.all;

    switch (data['count']) {
      case 'all':
        break;
      case 'any':
        type = GroupType.any;
        break;
      default:
        throw InvalidFormatExcepetion(
          "group count can not be of type ${data['count']}",
        );
    }

    var children = ((data['children'] ?? []) as List<dynamic>)
        .map((child) => DateRule.parse(child))
        .toList(growable: false);

    if (children.isEmpty) {
      return _NoChildrenRule(type, data['id'], data['name']);
    }
    switch (type) {
      case GroupType.any:
        return _AnyGroupRule(children, data['id'], data['name']);
      case GroupType.all:
        return _AllGroupRule(children, data['id'], data['name']);
    }
  }
}

abstract class _GroupRuleImplementation extends GroupDateRule {
  final List<DateRule> children;

  _GroupRuleImplementation(this.children, [String? id, String? name])
      : super(id, name);
}

class _AnyGroupRule extends _GroupRuleImplementation {
  _AnyGroupRule(List<DateRule> children, [String? id, String? name])
      : super(children, id, name);

  @override
  bool validate(DateTime time) {
    return children.any((element) => element.validate(time));
  }

  @override
  GroupType get type => GroupType.any;
}

class _AllGroupRule extends _GroupRuleImplementation {
  _AllGroupRule(List<DateRule> children, [String? id, String? name])
      : super(children, id, name);

  @override
  bool validate(DateTime time) {
    return !children.any((element) => !element.validate(time));
  }

  @override
  GroupType get type => GroupType.all;
}

class _NoChildrenRule extends GroupDateRule {
  final GroupType type;
  _NoChildrenRule(this.type, [String? id, String? name]) : super(id, name);

  @override
  bool validate(DateTime time) {
    return false;
  }

  @override
  List<DateRule> get children => const [];
}
