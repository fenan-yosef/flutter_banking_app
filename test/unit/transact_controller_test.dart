import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_banking_app/features/transact/data/mock_transact_repository.dart';
import 'package:flutter_banking_app/features/transact/presentation/controllers/transact_controller.dart';

void main() {
  group('TransactController', () {
    late MockTransactRepository repository;
    late TransactController controller;

    setUp(() {
      repository = MockTransactRepository();
      controller = TransactController(repository: repository);
    });

    test('initializes tokens and default swap conversion', () async {
      await controller.init();

      expect(controller.tokens.length, greaterThanOrEqualTo(4));
      expect(controller.fromToken?.symbol, 'BTC');
      expect(controller.toToken?.symbol, 'ETH');
      expect(controller.fromAmount, 0.05);
      expect(controller.toAmount, greaterThan(0.0));
      expect(controller.transactions, isNotEmpty);
    });

    test('recalculates toAmount when fromAmount changes', () async {
      await controller.init();

      controller.setFromAmount(1.0);
      final expectedTo = controller.fromToken!.usdPrice / controller.toToken!.usdPrice;

      expect(controller.toAmount, closeTo(expectedTo, 0.001));
    });

    test('reverseTokens swaps from and to and updates calculations', () async {
      await controller.init();

      final initialFrom = controller.fromToken;
      final initialTo = controller.toToken;

      controller.reverseTokens();

      expect(controller.fromToken, equals(initialTo));
      expect(controller.toToken, equals(initialFrom));
    });

    test('executeSwap adds transaction to history', () async {
      await controller.init();
      final initialCount = controller.transactions.length;

      final newTx = await controller.executeSwap();

      expect(newTx, isNotNull);
      expect(controller.transactions.length, equals(initialCount + 1));
      expect(controller.transactions.first.id, equals(newTx!.id));
    });

    test('filter works correctly for swaps and transfers', () async {
      await controller.init();

      controller.setFilter(HistoryFilter.swaps);
      expect(controller.transactions.every((t) => t.type.name == 'swap'), isTrue);

      controller.setFilter(HistoryFilter.transfers);
      expect(
        controller.transactions.every((t) => t.type.name == 'send' || t.type.name == 'receive'),
        isTrue,
      );
    });
  });
}
