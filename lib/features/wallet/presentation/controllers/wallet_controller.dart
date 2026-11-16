import 'package:flutter/material.dart';
import '../../domain/models/wallet_account.dart';
import '../../domain/repositories/wallet_repository.dart';

/// Reactive controller managing active wallet account, balance refresh,
/// and transaction flows.
class WalletController extends ChangeNotifier {
  final WalletRepository repository;

  WalletController({required this.repository});

  WalletAccount? _activeAccount;
  List<WalletAccount> _accounts = [];
  bool _isLoading = true;
  bool _isRefreshing = false;

  WalletAccount? get activeAccount => _activeAccount;
  List<WalletAccount> get accounts => _accounts;
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    _accounts = await repository.getAccounts();
    _activeAccount = await repository.getActiveAccount();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> switchAccount(String accountId) async {
    await repository.switchAccount(accountId);
    _activeAccount = await repository.getActiveAccount();
    notifyListeners();
  }

  Future<void> refresh() async {
    if (_isRefreshing) return;
    _isRefreshing = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 700));
    _activeAccount = await repository.getActiveAccount();

    _isRefreshing = false;
    notifyListeners();
  }

  Future<void> sendFunds({
    required String recipient,
    required double amount,
    required String symbol,
  }) async {
    await repository.sendFunds(
      recipientAddress: recipient,
      amount: amount,
      symbol: symbol,
    );
    _activeAccount = await repository.getActiveAccount();
    notifyListeners();
  }
}
