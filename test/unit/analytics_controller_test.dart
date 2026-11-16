import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_banking_app/features/analytics/data/mock_analytics_repository.dart';
import 'package:flutter_banking_app/features/analytics/domain/models/analytics_data.dart';
import 'package:flutter_banking_app/features/analytics/presentation/controllers/analytics_controller.dart';

void main() {
  group('AnalyticsController', () {
    late MockAnalyticsRepository repository;
    late AnalyticsController controller;

    setUp(() {
      repository = MockAnalyticsRepository();
      controller = AnalyticsController(repository: repository);
    });

    test('initial state and data loading', () async {
      expect(controller.selectedTimeframe, Timeframe.month1m);
      expect(controller.chartPoints, isEmpty);

      await controller.init();

      expect(controller.chartPoints, isNotEmpty);
      expect(controller.allocations, isNotEmpty);
      expect(controller.cashFlow, isNotNull);
      expect(controller.insights, isNotEmpty);
      expect(controller.displayValuation, greaterThan(15000.0));
    });

    test('timeframe switching updates chart points', () async {
      await controller.init();

      await controller.setTimeframe(Timeframe.day24h);
      expect(controller.selectedTimeframe, Timeframe.day24h);
      expect(controller.chartPoints.length, equals(7));

      await controller.setTimeframe(Timeframe.year1y);
      expect(controller.selectedTimeframe, Timeframe.year1y);
    });

    test('scrubbing updates displayValuation and tooltip', () async {
      await controller.init();

      final targetPoint = controller.chartPoints[2];
      controller.setScrubbedPoint(targetPoint);

      expect(controller.scrubbedPoint, equals(targetPoint));
      expect(controller.displayValuation, equals(targetPoint.value));

      controller.setScrubbedPoint(null);
      expect(controller.scrubbedPoint, isNull);
      expect(
        controller.displayValuation,
        equals(controller.chartPoints.last.value),
      );
    });

    test('period percentage calculation is accurate', () async {
      await controller.init();
      final expectedPct =
          ((controller.displayValuation - controller.chartPoints.first.value) /
              controller.chartPoints.first.value) *
          100;

      expect(controller.periodPercentageChange, closeTo(expectedPct, 0.01));
    });
  });
}
