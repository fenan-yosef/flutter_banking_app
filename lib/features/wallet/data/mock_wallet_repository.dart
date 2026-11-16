import '../domain/models/wallet_account.dart';
import '../domain/models/transaction.dart';
import '../domain/repositories/wallet_repository.dart';
import '../../../core/services/crypto_price_service.dart';

/// Concrete mock repository simulating client-side storage & network responses.
class MockWalletRepository implements WalletRepository {
  final CryptoPriceService _priceService = CryptoPriceService();

  List<WalletAccount> _accounts = [
    const WalletAccount(
      id: 'wallet_1',
      name: 'Wallet 1',
      fiatBalance: 2246.0,
      cryptoSymbol: 'XMR',
      cryptoBalance: 18.92, // 18.92 XMR @ $118.70 = $2,246.00
      isSynchronized: true,
      publicAddress: '888tNkZrPN6JsEgekjMnABU4TBWo2Dt2zTXu9...3Kx9',
    ),
    const WalletAccount(
      id: 'wallet_savings',
      name: 'Savings Vault',
      fiatBalance: 12450.0,
      cryptoSymbol: 'XMR',
      cryptoBalance: 104.89, // 104.89 XMR @ $118.70 = $12,450.00
      isSynchronized: true,
      publicAddress: '84sFkd9xMke83KsdLw01Ks93Klsm29Smd8...9Zp2',
    ),
    const WalletAccount(
      id: 'wallet_trading',
      name: 'Trading Account',
      fiatBalance: 95200.0,
      cryptoSymbol: 'XMR',
      cryptoBalance: 801.95, // 801.95 XMR @ $118.70 = $95,200.00
      isSynchronized: true,
      publicAddress: '83Lksmd92Kdks93Lksmd82Ksm291Ksmd82...4Qw1',
    ),
  ];

  String _activeAccountId = 'wallet_1';

  final List<WalletTransaction> _transactions = [
    WalletTransaction(
      id: 'tx_1',
      type: TransactionType.receive,
      assetSymbol: 'XMR',
      amount: 15.2,
      fiatAmount: 1804.24, // 15.2 * 118.70
      counterparty: 'MoneroPool Miner #4',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    WalletTransaction(
      id: 'tx_2',
      type: TransactionType.send,
      assetSymbol: 'BTC',
      amount: 0.05,
      fiatAmount: 3219.50, // 0.05 * 64,390
      counterparty: 'Hardware Cold Wallet',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  @override
  Future<List<WalletAccount>> getAccounts() async {
    return List.unmodifiable(_accounts);
  }

  @override
  Future<WalletAccount> getActiveAccount() async {
    return _accounts.firstWhere(
      (a) => a.id == _activeAccountId,
      orElse: () => _accounts.first,
    );
  }

  @override
  Future<void> switchAccount(String accountId) async {
    _activeAccountId = accountId;
  }

  @override
  Future<void> sendFunds({
    required String recipientAddress,
    required double amount,
    required String symbol,
  }) async {
    final unitPrice = _priceService.getPrice(symbol);
    final active = await getActiveAccount();
    final updated = active.copyWith(
      cryptoBalance: (active.cryptoBalance - amount).clamp(
        0.0,
        double.infinity,
      ),
      fiatBalance: (active.fiatBalance - (amount * unitPrice)).clamp(
        0.0,
        double.infinity,
      ),
    );

    _accounts = _accounts.map((a) => a.id == active.id ? updated : a).toList();

    _transactions.insert(
      0,
      WalletTransaction(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        type: TransactionType.send,
        assetSymbol: symbol,
        amount: amount,
        fiatAmount: amount * unitPrice,
        counterparty: recipientAddress,
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  Future<List<WalletTransaction>> getRecentTransactions() async {
    return List.unmodifiable(_transactions);
  }
}
