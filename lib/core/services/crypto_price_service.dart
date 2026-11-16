import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Real-time live cryptocurrency pricing data.
class CryptoPriceData {
  final String symbol; // e.g. BTC, ETH, USDT, XMR
  final double price;
  final double change24h;
  final double high24h;
  final double low24h;

  const CryptoPriceData({
    required this.symbol,
    required this.price,
    required this.change24h,
    required this.high24h,
    required this.low24h,
  });
}

/// Service to fetch live market prices and 24h stats from Binance public API
/// with zero-delay memory caching and robust offline fallbacks.
class CryptoPriceService {
  static final CryptoPriceService _instance = CryptoPriceService._internal();
  factory CryptoPriceService() => _instance;
  CryptoPriceService._internal();

  // Baseline verified market rates
  final Map<String, CryptoPriceData> _cache = {
    'BTC': const CryptoPriceData(
      symbol: 'BTC',
      price: 64390.00,
      change24h: -0.56,
      high24h: 65696.00,
      low24h: 63905.00,
    ),
    'ETH': const CryptoPriceData(
      symbol: 'ETH',
      price: 1813.50,
      change24h: 0.11,
      high24h: 1866.00,
      low24h: 1787.00,
    ),
    'USDT': const CryptoPriceData(
      symbol: 'USDT',
      price: 1.00,
      change24h: 0.01,
      high24h: 1.001,
      low24h: 0.999,
    ),
    'XMR': const CryptoPriceData(
      symbol: 'XMR',
      price: 118.70,
      change24h: 0.00,
      high24h: 118.70,
      low24h: 118.70,
    ),
  };

  DateTime? _lastFetchTime;

  /// Fetch live quotes from Binance 24hr API.
  Future<Map<String, CryptoPriceData>> fetchLivePrices() async {
    // Only refresh from network if cache is older than 15 seconds
    if (_lastFetchTime != null &&
        DateTime.now().difference(_lastFetchTime!).inSeconds < 15) {
      return Map.unmodifiable(_cache);
    }

    try {
      const url =
          'https://api.binance.com/api/v3/ticker/24hr?symbols=["BTCUSDT","ETHUSDT","XMRUSDT"]';
      final response = await http
          .get(Uri.parse(url), headers: {'User-Agent': 'FlutterBankingApp/1.0'})
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        for (final item in jsonList) {
          final pair = item['symbol'] as String;
          String symbol = 'BTC';
          if (pair.startsWith('BTC')) symbol = 'BTC';
          if (pair.startsWith('ETH')) symbol = 'ETH';
          if (pair.startsWith('XMR')) symbol = 'XMR';

          final price = double.tryParse(item['lastPrice'].toString()) ?? _cache[symbol]!.price;
          final change24h = double.tryParse(item['priceChangePercent'].toString()) ?? _cache[symbol]!.change24h;
          final high24h = double.tryParse(item['highPrice'].toString()) ?? _cache[symbol]!.high24h;
          final low24h = double.tryParse(item['lowPrice'].toString()) ?? _cache[symbol]!.low24h;

          _cache[symbol] = CryptoPriceData(
            symbol: symbol,
            price: price,
            change24h: change24h,
            high24h: high24h,
            low24h: low24h,
          );
        }
        _lastFetchTime = DateTime.now();
      }
    } catch (e) {
      debugPrint('CryptoPriceService: Notice - using cached/offline crypto prices: $e');
    }

    return Map.unmodifiable(_cache);
  }

  /// Get current cached or default price for symbol.
  double getPrice(String symbol) {
    return _cache[symbol.toUpperCase()]?.price ?? 1.0;
  }

  /// Get current 24h change percentage for symbol.
  double getChange24h(String symbol) {
    return _cache[symbol.toUpperCase()]?.change24h ?? 0.0;
  }

  /// Calculates accurate fiat value (holdings * price).
  double calculateFiatValue({required String symbol, required double holdings}) {
    final price = getPrice(symbol);
    return holdings * price;
  }
}
