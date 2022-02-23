import 'package:test/test.dart';

import 'package:date_rule/date_rule.dart';

void main() {
  group("#DayOfWeekDateRule", () {
    final combinations = [
      List.generate(0, (i) => i),
      List.generate(1, (i) => i),
      List.generate(2, (i) => i),
      List.generate(3, (i) => i),
      List.generate(4, (i) => i),
      List.generate(5, (i) => i),
      List.generate(6, (i) => i),
      List.generate(7, (i) => i),
    ];
    group("Testing day combinations", () {
      for (var x = 0; x < combinations.length; x++) {
        var element = combinations[x];
        test("testing combinations of ${element.length} item(s) per week", () {
          var rule = DayOfWeekDateRule(element);
          for (var i = 0; i < 3650; i++) {
            final baseDay = DateTime.now().add(Duration(days: i));

            var count = List.generate(7, (i) => i)
                .where((e) => rule.validate(baseDay.add(Duration(days: e))))
                .length;

            expect(count, element.length,
                reason: "Expected only ${element.length} items, got $count");
          }
        });
      }
    });

    group("days are correct", () {
      final base = DateTime.parse("2022-02-13");
      List<String> days = [
        'Sunday',
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday'
      ];

      for (var i = 0; i < days.length; i++) {
        test("Testing that value $i is a ${days[i]}", () {
          var date = base.add(Duration(days: i, seconds: 1));
          var rule = DayOfWeekDateRule([i]);
          expect(rule.validate(date), true,
              reason:
                  "Expecting ${date.toString()} to be a ${days[i]}, (raw value=${date.weekday}, parsed=${rule.days})");
        });
      }
    });
  });
}
