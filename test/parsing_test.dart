import 'dart:convert';

import 'package:test/test.dart';

import '../bin/date_rule.dart';

void main() {
  group("jsonDecoding works", () {
    test("can deserialize all group rules", () {
      var str =
          '{"type": "group", "count":"all", "children": [{"type":"yes"}]}';
      var rule = DateRule.parse(jsonDecode(str));
      expect(rule.runtimeType.toString(), "_AllGroupRule",
          reason: "Expected rule to be a group date rule");
    });

    test("can deserialize any group rules", () {
      var str =
          '{"type": "group", "count": "any", "children": [{"type":"yes"}]}';
      var rule = DateRule.parse(jsonDecode(str));
      expect(rule.runtimeType.toString(), "_AnyGroupRule",
          reason: "Expected rule to be a group date rule");
    });

    test("can deserialize empty group rules", () {
      var str = '{"type": "group", "count": "any", "children": []}';
      var rule = DateRule.parse(jsonDecode(str));
      expect(rule.runtimeType.toString(), "_NoChildrenRule",
          reason: "Expected rule to be a group date rule");
    });

    test("can deserialize not rules", () {
      var str = '{"type": "not", "child": {"type":"yes"}}';
      var rule = DateRule.parse(jsonDecode(str));
      expect(rule.runtimeType, NotRule,
          reason: "Expected rule to be a not date rule");
    });
    test("can deserialize not rules without child", () {
      var str = '{"type": "not", "child": null}';
      var rule = DateRule.parse(jsonDecode(str));
      expect(rule.runtimeType, NotRule,
          reason: "Expected rule to be a not date rule");
    });

    test("can deserialize date rules", () {
      var str =
          '{"type": "dateRange", "from": "2021-01-01", "to": "2022-01-01"}';
      DateRangeRule rule = DateRule.parse(jsonDecode(str)) as DateRangeRule;

      expect(
          rule.from?.isAtSameMomentAs(DateTime(2021, 01, 01, 00, 00, 00)), true,
          reason: "Expected date to be at correct time");
    });
  });

  group("default values", () {
    test("NotRule gets id if none is supplied", () {
      var n2 = NotRule(id: "test", child: AlwaysTrueRule());
      expect(n2.id, "test");
    });
  });

  group("Parsing", () {
    test('DateRule.parse() can parse not rules', () {
      var rule = DateRule.parse({
        'type': 'not',
        'child': {'type': 'yes'}
      });
      expect(rule is NotRule, true);
    });

    group("DateRule.parse() can parse group rules", () {
      test("can parse any group rules", () {
        var rule =
            DateRule.parse({'type': 'group', 'count': 'any', 'children': []});

        expect(rule is GroupDateRule, true);
      });

      test(" can parse all group rules", () {
        var rule =
            DateRule.parse({'type': 'group', 'count': 'all', 'children': []});

        expect(rule is GroupDateRule, true);
      });

      test("can parse containing rules", () {
        var rule = DateRule.parse({
          'type': 'group',
          'count': 'all',
          'children': [
            {
              'type': 'not',
              'child': {'type': 'no'},
            },
          ]
        });

        expect(rule is GroupDateRule, true);
        expect((rule as GroupDateRule).children.first is NotRule, true,
            reason:
                "type is actually: ${(rule as GroupDateRule).children.first.runtimeType}");
      });

      test("throws invalid format exception if count is unmatchable", () {
        try {
          var rule = DateRule.parse({
            'type': 'group',
            'count': 'alles',
            'children': [
              {
                'type': 'not',
                'child': {'type': 'no'},
              },
            ]
          });
          expect(true, false,
              reason:
                  "This rule should never be validated, it should fail before this");
        } on Exception catch (e) {
          expect(e.runtimeType, InvalidFormatExcepetion);
        }
      });
    });

    group("DateRule.parse() can parse dateRange rules", () {});
  });
}
