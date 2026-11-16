import 'package:flutter/material.dart';

enum AssetCategory { all, crypto, fiat }

/// Immutable model representing a cryptocurrency or fiat asset in the portfolio.
class CryptoAsset {
  final String id;
  final String name;
  final String symbol;
  final double holdings;
  final double fiatValue;
  final double change24h;
  final Color brandColor;
  final String iconPath;
  final List<double> sparkline;
  final AssetCategory category;
  final bool isFeatured;

  const CryptoAsset({
    required this.id,
    required this.name,
    required this.symbol,
    required this.holdings,
    required this.fiatValue,
    required this.change24h,
    required this.brandColor,
    required this.iconPath,
    required this.sparkline,
    this.category = AssetCategory.crypto,
    this.isFeatured = false,
  });

  bool get isPositive => change24h >= 0;
}
