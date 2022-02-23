import 'package:date_rule/date_rule.dart';
import 'package:test/test.dart';

void runTestOnRange(List<int> years, List<String> _validDates,
    List<String> _invalidDates, DateRule rule) {
  final validDates = _validDates.map((date) => DateTime.parse(date));
  final invalidDates = _invalidDates.map((date) => DateTime.parse(date));

  for (var element in years) {
    group("it validates correctly for days of year $element", () {
      validDates
          .map((date) => DateTime(element, date.month, date.day))
          .forEach((date) {
        test(date, () {
          expect(rule.validate(date), true,
              reason: "Expected date: $date to pass");
        });
      });
    });
    group("it does not validate correctly for days of year $element", () {
      invalidDates
          .map((date) => DateTime(element, date.month, date.day))
          .forEach((date) {
        test(date, () {
          expect(rule.validate(date), false,
              reason: "Expected date: $date to not pass");
        });
      });
    });
  }
}

void main() {
  group("#RecurringDateRangeDateRule", () {
    const years = [
      1000,
      1100,
      1200,
      1300,
      1400,
      1500,
      1600,
      1700,
      1800,
      1900,
      2000,
      2010,
      2020,
      2030,
      2040,
      2050,
      1337
    ];

    group("validates correctly when crossing years", () {
      const validDates = [
        "1900-12-24",
        "1900-01-05",
        "1900-01-07",
      ];

      const invalidDates = ["1900-12-23", "1900-01-08", "1900-03-01"];

      final rule = RecurringDateRangeDateRule.fromInterval(
        RecurringDateRangeInverval.yearly,
        DateTime.parse("0001-12-24"),
        DateTime.parse("0002-01-08"),
      );
      runTestOnRange(years, validDates, invalidDates, rule);
    });

    group("validates monthly crossing years", () {
      const validDates = [
        "1900-01-24",
        "1900-01-07",
        "1900-02-24",
        "1900-02-07",
        "1900-03-24",
        "1900-03-07",
        "1900-04-24",
        "1900-04-07",
        "1900-05-24",
        "1900-05-07",
        "1900-06-24",
        "1900-06-07",
        "1900-07-24",
        "1900-07-07",
        "1900-08-24",
        "1900-08-07",
        "1900-09-24",
        "1900-09-07",
      ];

      const invalidDates = [
        "1900-12-23",
        "1900-01-08",
        "1900-01-23",
        "1900-02-08",
        "1900-02-23",
        "1900-03-08",
        "1900-03-23",
        "1900-04-08",
        "1900-04-23",
        "1900-05-08",
        "1900-05-23",
        "1900-06-08",
        "1900-06-23",
        "1900-07-08",
        "1900-07-23",
        "1900-08-08",
        "1900-08-23",
        "1900-09-08",
        "1900-09-23",
        "1900-10-08",
        "1900-10-23",
        "1900-11-08",
        "1900-11-23",
        "1900-12-08"
      ];

      final rule = RecurringDateRangeDateRule.fromInterval(
        RecurringDateRangeInverval.monthly,
        DateTime.parse("0001-12-24"),
        DateTime.parse("0002-01-08"),
      );

      runTestOnRange(years, validDates, invalidDates, rule);
    });

    group("validates yearly", () {
      const validDates = [
        "1900-02-01",
        "1900-02-02",
        "1900-02-03",
        "1900-02-04",
        "1900-02-05",
        "1900-02-06",
        "1900-02-07"
      ];

      const invalidDates = [
        "1900-01-31",
        "1900-02-08",
        "1900-03-01",
        "1900-01-01"
      ];

      final rule = RecurringDateRangeDateRule.fromInterval(
        RecurringDateRangeInverval.yearly,
        DateTime.parse("0001-02-01"),
        DateTime.parse("0001-02-08"),
      );

      runTestOnRange(years, validDates, invalidDates, rule);
    });

    group("validates monthly", () {
      const validDates = [
        "1900-02-01",
        "1900-02-02",
        "1900-02-03",
        "1900-02-04",
        "1900-02-05",
        "1900-02-06",
        "1900-02-07",

        // Same each month
        "1900-03-01",
        "1900-03-02",
        "1900-03-03",
        "1900-03-04",
        "1900-03-05",
        "1900-03-06",
        "1900-03-07",

        "1900-04-01",
        "1900-04-02",
        "1900-04-03",
        "1900-04-04",
        "1900-04-05",
        "1900-04-06",
        "1900-04-07",
      ];

      const invalidDates = [
        "1900-01-08",
        "1900-02-12",
        "1900-01-31",
        "1900-02-08",
        "1900-03-08",
        "1900-04-08",
        "1900-05-08",
        "1900-06-08",
        "1900-07-08",
      ];

      final rule = RecurringDateRangeDateRule.fromInterval(
        RecurringDateRangeInverval.monthly,
        DateTime.parse("0001-01-01"),
        DateTime.parse("0001-01-08"),
      );

      runTestOnRange(years, validDates, invalidDates, rule);
    });
  });
}
