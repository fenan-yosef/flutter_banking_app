import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_banking_app/core/utils/currency_formatter.dart';

void main() {
  group('CurrencyFormatter', () {
    test('formatFiat formats integer amounts with dollar sign and commas', () {
      expect(CurrencyFormatter.formatFiat(2246), '\$2,246');
      expect(CurrencyFormatter.formatFiat(1908), '\$1,908');
      expect(CurrencyFormatter.formatFiat(0), '\$0');
    });

    test('formatFiat formats with cents when showCents is true', () {
      expect(CurrencyFormatter.formatFiat(640.03, showCents: true), '\$640.03');
    });

    test('formatCrypto formats crypto amounts with symbol', () {
      expect(CurrencyFormatter.formatCrypto(210.43, 'XMR'), '210.43 XMR');
      expect(CurrencyFormatter.formatCrypto(100.0, 'USDT'), '100 USDT');
      expect(CurrencyFormatter.formatCrypto(0.153, 'BTC'), '0.153 BTC');
    });
  });
}
