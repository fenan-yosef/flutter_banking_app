import 'package:intl/intl.dart';

/// Formatting utilities for currency and cryptocurrency amounts.
class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _fiatFormat = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 0,
  );

  static final NumberFormat _fiatDetailFormat = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );

  static String formatFiat(double amount, {bool showCents = false}) {
    if (showCents) {
      return _fiatDetailFormat.format(amount);
    }
    return _fiatFormat.format(amount);
  }

  static String formatUsd(double amount, {bool showCents = false}) {
    final hasCents = showCents || (amount % 1 != 0 && amount < 1000);
    return formatFiat(amount, showCents: hasCents);
  }

  static String formatCrypto(double amount, String symbol) {
    // Preserve natural decimals without trailing zero clutter:
    // e.g. 210.43 -> "210.43 XMR", 100.0 -> "100 USDT", 0.153 -> "0.153 BTC"
    final formatted = amount.toString().replaceAll(RegExp(r'\.0$'), '');
    return '$formatted $symbol';
  }
}
