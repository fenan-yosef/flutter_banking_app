import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/crypto_price_service.dart';
import '../domain/models/analytics_data.dart';

abstract class AnalyticsRepository {
  Future<List<ChartPoint>> getChartData(Timeframe timeframe);
  Future<List<AssetAllocation>> getAssetAllocations();
  Future<CashFlowSummary> getCashFlowSummary();
  Future<List<MarketInsight>> getMarketInsights();
}

class MockAnalyticsRepository implements AnalyticsRepository {
  final CryptoPriceService _priceService = CryptoPriceService();

  Future<double> _calculateTotalPortfolio() async {
    await _priceService.fetchLivePrices();
    final btcVal = 0.153 * _priceService.getPrice('BTC');
    final ethVal = 1.278 * _priceService.getPrice('ETH');
    final usdtVal = 1908.0 * _priceService.getPrice('USDT');
    final xmrVal = 18.92 * _priceService.getPrice('XMR');
    return btcVal + ethVal + usdtVal + xmrVal;
  }

  @override
  Future<List<ChartPoint>> getChartData(Timeframe timeframe) async {
    final total = await _calculateTotalPortfolio();
    final now = DateTime.now();

    switch (timeframe) {
      case Timeframe.day24h:
        return [
          ChartPoint(
            timestamp: now.subtract(const Duration(hours: 24)),
            value: total * 0.985,
            label: '00:00',
          ),
          ChartPoint(
            timestamp: now.subtract(const Duration(hours: 20)),
            value: total * 0.991,
            label: '04:00',
          ),
          ChartPoint(
            timestamp: now.subtract(const Duration(hours: 16)),
            value: total * 0.988,
            label: '08:00',
          ),
          ChartPoint(
            timestamp: now.subtract(const Duration(hours: 12)),
            value: total * 0.995,
            label: '12:00',
          ),
          ChartPoint(
            timestamp: now.subtract(const Duration(hours: 8)),
            value: total * 0.998,
            label: '16:00',
          ),
          ChartPoint(
            timestamp: now.subtract(const Duration(hours: 4)),
            value: total * 0.994,
            label: '20:00',
          ),
          ChartPoint(timestamp: now, value: total, label: 'Now'),
        ];

      case Timeframe.week1w:
        return [
          ChartPoint(
            timestamp: now.subtract(const Duration(days: 7)),
            value: total * 0.935,
            label: 'Mon',
          ),
          ChartPoint(
            timestamp: now.subtract(const Duration(days: 6)),
            value: total * 0.948,
            label: 'Tue',
          ),
          ChartPoint(
            timestamp: now.subtract(const Duration(days: 5)),
            value: total * 0.970,
            label: 'Wed',
          ),
          ChartPoint(
            timestamp: now.subtract(const Duration(days: 4)),
            value: total * 0.962,
            label: 'Thu',
          ),
          ChartPoint(
            timestamp: now.subtract(const Duration(days: 3)),
            value: total * 0.982,
            label: 'Fri',
          ),
          ChartPoint(
            timestamp: now.subtract(const Duration(days: 2)),
            value: total * 0.992,
            label: 'Sat',
          ),
          ChartPoint(
            timestamp: now.subtract(const Duration(days: 1)),
            value: total * 0.988,
            label: 'Sun',
          ),
          ChartPoint(timestamp: now, value: total, label: 'Today'),
        ];

      case Timeframe.month1m:
        return [
          ChartPoint(
            timestamp: now.subtract(const Duration(days: 30)),
            value: total * 0.835,
            label: 'Oct 17',
          ),
          ChartPoint(
            timestamp: now.subtract(const Duration(days: 25)),
            value: total * 0.862,
            label: 'Oct 22',
          ),
          ChartPoint(
            timestamp: now.subtract(const Duration(days: 20)),
            value: total * 0.858,
            label: 'Oct 27',
          ),
          ChartPoint(
            timestamp: now.subtract(const Duration(days: 15)),
            value: total * 0.912,
            label: 'Nov 01',
          ),
          ChartPoint(
            timestamp: now.subtract(const Duration(days: 10)),
            value: total * 0.948,
            label: 'Nov 06',
          ),
          ChartPoint(
            timestamp: now.subtract(const Duration(days: 5)),
            value: total * 0.978,
            label: 'Nov 11',
          ),
          ChartPoint(timestamp: now, value: total, label: 'Nov 16'),
        ];

      case Timeframe.year1y:
        return [
          ChartPoint(
            timestamp: now.subtract(const Duration(days: 365)),
            value: total * 0.61,
            label: 'Jan',
          ),
          ChartPoint(
            timestamp: now.subtract(const Duration(days: 300)),
            value: total * 0.67,
            label: 'Mar',
          ),
          ChartPoint(
            timestamp: now.subtract(const Duration(days: 240)),
            value: total * 0.76,
            label: 'May',
          ),
          ChartPoint(
            timestamp: now.subtract(const Duration(days: 180)),
            value: total * 0.72,
            label: 'Jul',
          ),
          ChartPoint(
            timestamp: now.subtract(const Duration(days: 120)),
            value: total * 0.82,
            label: 'Sep',
          ),
          ChartPoint(
            timestamp: now.subtract(const Duration(days: 60)),
            value: total * 0.92,
            label: 'Oct',
          ),
          ChartPoint(timestamp: now, value: total, label: 'Nov'),
        ];

      case Timeframe.allTime:
        return [
          ChartPoint(
            timestamp: now.subtract(const Duration(days: 730)),
            value: total * 0.38,
            label: '2024',
          ),
          ChartPoint(
            timestamp: now.subtract(const Duration(days: 540)),
            value: total * 0.55,
            label: 'Mid 24',
          ),
          ChartPoint(
            timestamp: now.subtract(const Duration(days: 365)),
            value: total * 0.67,
            label: '2025',
          ),
          ChartPoint(
            timestamp: now.subtract(const Duration(days: 180)),
            value: total * 0.86,
            label: 'Mid 25',
          ),
          ChartPoint(timestamp: now, value: total, label: '2026'),
        ];
    }
  }

  @override
  Future<List<AssetAllocation>> getAssetAllocations() async {
    await _priceService.fetchLivePrices();

    final btcVal = 0.153 * _priceService.getPrice('BTC');
    final ethVal = 1.278 * _priceService.getPrice('ETH');
    final usdtVal = 1908.0 * _priceService.getPrice('USDT');
    final xmrVal = 18.92 * _priceService.getPrice('XMR');
    final total = btcVal + ethVal + usdtVal + xmrVal;

    return [
      AssetAllocation(
        symbol: 'BTC',
        name: 'Bitcoin',
        percentage: (btcVal / total) * 100,
        color: AppColors.bitcoinOrange,
        usdValue: btcVal,
      ),
      AssetAllocation(
        symbol: 'ETH',
        name: 'Ethereum',
        percentage: (ethVal / total) * 100,
        color: AppColors.ethereumViolet,
        usdValue: ethVal,
      ),
      AssetAllocation(
        symbol: 'USDT',
        name: 'Tether',
        percentage: (usdtVal / total) * 100,
        color: AppColors.tetherTeal,
        usdValue: usdtVal,
      ),
      AssetAllocation(
        symbol: 'XMR',
        name: 'Monero',
        percentage: (xmrVal / total) * 100,
        color: AppColors.moneroOrange,
        usdValue: xmrVal,
      ),
    ];
  }

  @override
  Future<CashFlowSummary> getCashFlowSummary() async {
    return const CashFlowSummary(
      income: 12850.00,
      spending: 4320.00,
      netSavings: 8530.00,
      savingsRate: 0.664,
    );
  }

  @override
  Future<List<MarketInsight>> getMarketInsights() async {
    return const [
      MarketInsight(
        id: '1',
        title: 'BTC Dominance Up',
        description:
            'Bitcoin dominance reached 58.2% this week, showing strong institutional accumulation.',
        badge: '+3.4%',
        icon: Icons.trending_up_rounded,
        isPositive: true,
      ),
      MarketInsight(
        id: '2',
        title: 'Gas Fees Optimal',
        description:
            'Current Ethereum base fee is 12 Gwei. Ideal window for staking and swaps.',
        badge: 'Low',
        icon: Icons.local_gas_station_rounded,
        isPositive: true,
      ),
      MarketInsight(
        id: '3',
        title: 'Portfolio Diversification',
        description:
            'Your assets have a Sharpe ratio of 2.14, outperforming the crypto market benchmark.',
        badge: 'Top 5%',
        icon: Icons.shield_rounded,
        isPositive: true,
      ),
    ];
  }
}
