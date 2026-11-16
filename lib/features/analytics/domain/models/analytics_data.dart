import 'package:flutter/material.dart';

/// Supported chart timeframes.
enum Timeframe {
  day24h('24H'),
  week1w('7D'),
  month1m('1M'),
  year1y('1Y'),
  allTime('ALL');

  final String label;
  const Timeframe(this.label);
}

/// A point on the analytics chart.
class ChartPoint {
  final DateTime timestamp;
  final double value;
  final String label;

  const ChartPoint({
    required this.timestamp,
    required this.value,
    required this.label,
  });
}

/// Representation of an asset's allocation in the portfolio.
class AssetAllocation {
  final String symbol;
  final String name;
  final double percentage; // e.g. 54.0 for 54%
  final Color color;
  final double usdValue;

  const AssetAllocation({
    required this.symbol,
    required this.name,
    required this.percentage,
    required this.color,
    required this.usdValue,
  });
}

/// Cash flow metrics (Income, Spending, Savings).
class CashFlowSummary {
  final double income;
  final double spending;
  final double netSavings;
  final double savingsRate; // e.g. 0.38 for 38%

  const CashFlowSummary({
    required this.income,
    required this.spending,
    required this.netSavings,
    required this.savingsRate,
  });
}

/// Smart market or account insight card.
class MarketInsight {
  final String id;
  final String title;
  final String description;
  final String badge;
  final IconData icon;
  final bool isPositive;

  const MarketInsight({
    required this.id,
    required this.title,
    required this.description,
    required this.badge,
    required this.icon,
    this.isPositive = true,
  });
}
