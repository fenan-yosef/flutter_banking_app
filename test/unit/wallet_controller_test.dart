import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_banking_app/features/wallet/data/mock_wallet_repository.dart';
import 'package:flutter_banking_app/features/wallet/presentation/controllers/wallet_controller.dart';

void main() {
  group('WalletController', () {
    late MockWalletRepository repo;
    late WalletController controller;

    setUp(() {
      repo = MockWalletRepository();
      controller = WalletController(repository: repo);
    });

    test('initializes with default active account and accounts list', () async {
      await controller.init();

      expect(controller.isLoading, isFalse);
      expect(controller.accounts.length, 3);
      expect(controller.activeAccount?.name, 'Wallet 1');
      expect(controller.activeAccount?.fiatBalance, 2246.0);
      expect(controller.activeAccount?.cryptoBalance, 18.92);
      expect(controller.activeAccount?.cryptoSymbol, 'XMR');
    });

    test('switches active account', () async {
      await controller.init();
      await controller.switchAccount('wallet_savings');

      expect(controller.activeAccount?.name, 'Savings Vault');
      expect(controller.activeAccount?.fiatBalance, 12450.0);
    });

    test('sendFunds decrements balance and notifies listeners', () async {
      await controller.init();
      final initialBalance = controller.activeAccount!.cryptoBalance;

      await controller.sendFunds(
        recipient: 'recipient_address_123',
        amount: 10.0,
        symbol: 'XMR',
      );

      expect(controller.activeAccount?.cryptoBalance, initialBalance - 10.0);
    });
  });
}
