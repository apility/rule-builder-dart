import 'package:test/test.dart';

import '../bin/date_rule.dart';

void main() {
  group("#DateRangeRule", () {
    final DateTime from = DateTime.parse("2021-02-01");
    final DateTime to = DateTime.parse("2021-03-01");

    test("Includes start time", () {
      var rule = DateRangeRule(from, to);
      expect(rule.validate(from), true);
      expect(rule.validate(from.add(Duration(seconds: 1))), true);
      expect(rule.validate(from.subtract(Duration(seconds: 1))), false);
    });

    test("Does not include end time", () {
      var rule = DateRangeRule(from, to);
      expect(rule.validate(to), false);
      expect(rule.validate(to.add(Duration(seconds: 1))), false);
      expect(rule.validate(to.subtract(Duration(seconds: 1))), true);
    });

    test("Allows any date before to if from is missing", () {
      var rule = DateRangeRule(null, to);
      expect(rule.validate(to), false);
      expect(rule.validate(to.subtract(Duration(seconds: 1))), true);

      for (var i = 1; i < 10000; i++) {
        var beforeDate = to.subtract(Duration(days: i * 7));
        var afterDate = to.add(Duration(days: i * 7));

        expect(
          rule.validate(beforeDate),
          true,
          reason: "Expected $beforeDate to produce a true response",
        );
        expect(
          rule.validate(afterDate),
          false,
          reason: "Expected $afterDate to produce a true response",
        );
      }
    });
  });
}
