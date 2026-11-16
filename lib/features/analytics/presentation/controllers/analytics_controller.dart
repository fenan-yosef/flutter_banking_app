import 'package:flutter/material.dart';
import '../../data/mock_analytics_repository.dart';
import '../../domain/models/analytics_data.dart';

class AnalyticsController extends ChangeNotifier {
  final AnalyticsRepository repository;

  AnalyticsController({required this.repository});

  Timeframe _selectedTimeframe = Timeframe.month1m;
  List<ChartPoint> _chartPoints = [];
  List<AssetAllocation> _allocations = [];
  CashFlowSummary? _cashFlow;
  List<MarketInsight> _insights = [];

  ChartPoint? _scrubbedPoint;
  bool _isLoading = false;

  Timeframe get selectedTimeframe => _selectedTimeframe;
  List<ChartPoint> get chartPoints => _chartPoints;
  List<AssetAllocation> get allocations => _allocations;
  CashFlowSummary? get cashFlow => _cashFlow;
  List<MarketInsight> get insights => _insights;
  ChartPoint? get scrubbedPoint => _scrubbedPoint;
  bool get isLoading => _isLoading;

  /// Current display valuation: either scrubbed point or the latest valuation.
  double get displayValuation {
    if (_scrubbedPoint != null) {
      return _scrubbedPoint!.value;
    }
    return _chartPoints.isNotEmpty ? _chartPoints.last.value : 2246.0;
  }

  /// Change between initial point in current timeframe and display point.
  double get periodAbsoluteChange {
    if (_chartPoints.isEmpty) return 0.0;
    final initial = _chartPoints.first.value;
    return displayValuation - initial;
  }

  double get periodPercentageChange {
    if (_chartPoints.isEmpty) return 0.0;
    final initial = _chartPoints.first.value;
    if (initial == 0) return 0.0;
    return ((displayValuation - initial) / initial) * 100;
  }

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    _chartPoints = await repository.getChartData(_selectedTimeframe);
    _allocations = await repository.getAssetAllocations();
    _cashFlow = await repository.getCashFlowSummary();
    _insights = await repository.getMarketInsights();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> setTimeframe(Timeframe timeframe) async {
    if (_selectedTimeframe == timeframe) return;
    _selectedTimeframe = timeframe;
    _scrubbedPoint = null;
    notifyListeners();

    _chartPoints = await repository.getChartData(timeframe);
    notifyListeners();
  }

  void setScrubbedPoint(ChartPoint? point) {
    if (_scrubbedPoint == point) return;
    _scrubbedPoint = point;
    notifyListeners();
  }
}
