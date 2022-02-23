import 'package:test/test.dart';

import '../bin/date_rule.dart';

void main() {
  group("#GroupDateRule", () {
    group("with all count", () {
      test("Will return false if any member is false", () {
        var rule = GroupDateRule.ofType(GroupType.all,
            [AlwaysTrueRule(), AlwaysTrueRule(), AlwaysFalseRule()]);

        expect(rule.validate(DateTime.now()), false);
      });

      test("Will return true if no member is false", () {
        var rule = GroupDateRule.ofType(GroupType.all,
            [AlwaysTrueRule(), AlwaysTrueRule(), AlwaysTrueRule()]);

        expect(rule.validate(DateTime.now()), true);
      });
    });

    group("with any count", () {
      test("Will return false if all member is false", () {
        var rule = GroupDateRule.ofType(GroupType.any,
            [AlwaysFalseRule(), AlwaysFalseRule(), AlwaysFalseRule()]);

        expect(rule.validate(DateTime.now()), false);
      });

      test("Will return true if atleast one member is true", () {
        var rule = GroupDateRule.ofType(GroupType.any,
            [AlwaysTrueRule(), AlwaysFalseRule(), AlwaysFalseRule()]);

        expect(rule.validate(DateTime.now()), true);
      });
    });

    group("with no sub rules", () {
      test("Will return false if no rules are present", () {
        var rule = GroupDateRule.ofType(GroupType.all, []);
        expect(rule.validate(DateTime.now()), false);

        var rule2 = GroupDateRule.ofType(GroupType.any, []);
        expect(rule2.validate(DateTime.now()), false);
      });
    });
  });
}
