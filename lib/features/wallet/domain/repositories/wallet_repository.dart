import '../models/wallet_account.dart';
import '../models/transaction.dart';

/// Abstract contract for wallet operations.
abstract class WalletRepository {
  Future<List<WalletAccount>> getAccounts();
  Future<WalletAccount> getActiveAccount();
  Future<void> switchAccount(String accountId);
  Future<void> sendFunds({
    required String recipientAddress,
    required double amount,
    required String symbol,
  });
  Future<List<WalletTransaction>> getRecentTransactions();
}
