import 'package:flutter/material.dart';
import '../../data/mock_transact_repository.dart';
import '../../domain/models/transaction_item.dart';

enum TransactMode { swap, send, buy }

enum HistoryFilter { all, swaps, transfers }

class TransactController extends ChangeNotifier {
  final TransactRepository repository;

  TransactController({required this.repository});

  TransactMode _mode = TransactMode.swap;
  HistoryFilter _filter = HistoryFilter.all;

  List<CryptoToken> _tokens = [];
  List<TransactionItem> _transactions = [];

  CryptoToken? _fromToken;
  CryptoToken? _toToken;
  double _fromAmount = 0.0;
  double _toAmount = 0.0;
  double _slippageTolerance = 0.5; // 0.5%
  final double _estimatedGasFee = 1.85; // USD
  bool _isLoading = false;
  bool _isSwapping = false;

  void setSlippageTolerance(double tolerance) {
    if (_slippageTolerance == tolerance) return;
    _slippageTolerance = tolerance;
    notifyListeners();
  }

  TransactMode get mode => _mode;
  HistoryFilter get filter => _filter;
  List<CryptoToken> get tokens => _tokens;
  List<TransactionItem> get transactions => _filteredTransactions;
  CryptoToken? get fromToken => _fromToken;
  CryptoToken? get toToken => _toToken;
  double get fromAmount => _fromAmount;
  double get toAmount => _toAmount;
  double get slippageTolerance => _slippageTolerance;
  double get estimatedGasFee => _estimatedGasFee;
  bool get isLoading => _isLoading;
  bool get isSwapping => _isSwapping;

  List<TransactionItem> get _filteredTransactions {
    switch (_filter) {
      case HistoryFilter.all:
        return _transactions;
      case HistoryFilter.swaps:
        return _transactions.where((t) => t.type == TransactionType.swap).toList();
      case HistoryFilter.transfers:
        return _transactions
            .where((t) => t.type == TransactionType.send || t.type == TransactionType.receive)
            .toList();
    }
  }

  /// Exchange rate ratio (1 From = X To).
  double get exchangeRate {
    if (_fromToken == null || _toToken == null || _toToken!.usdPrice == 0) return 0.0;
    return _fromToken!.usdPrice / _toToken!.usdPrice;
  }

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    _tokens = await repository.getSupportedTokens();
    _transactions = await repository.getTransactionHistory();

    if (_tokens.isNotEmpty) {
      _fromToken = _tokens.firstWhere((t) => t.symbol == 'BTC', orElse: () => _tokens[0]);
      _toToken = _tokens.firstWhere((t) => t.symbol == 'ETH', orElse: () => _tokens.length > 1 ? _tokens[1] : _tokens[0]);
      setFromAmount(0.05); // sensible starting demo input
    }

    _isLoading = false;
    notifyListeners();
  }

  void setMode(TransactMode mode) {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
  }

  void setFilter(HistoryFilter filter) {
    if (_filter == filter) return;
    _filter = filter;
    notifyListeners();
  }

  void setFromToken(CryptoToken token) {
    if (_fromToken == token) return;
    if (_toToken == token) {
      // Auto flip if user picks same token
      _toToken = _fromToken;
    }
    _fromToken = token;
    _recalculateToAmount();
    notifyListeners();
  }

  void setToToken(CryptoToken token) {
    if (_toToken == token) return;
    if (_fromToken == token) {
      // Auto flip if user picks same token
      _fromToken = _toToken;
    }
    _toToken = token;
    _recalculateToAmount();
    notifyListeners();
  }

  void setFromAmount(double amount) {
    _fromAmount = amount;
    _recalculateToAmount();
    notifyListeners();
  }

  void reverseTokens() {
    final temp = _fromToken;
    _fromToken = _toToken;
    _toToken = temp;
    _recalculateToAmount();
    notifyListeners();
  }

  void _recalculateToAmount() {
    if (_fromToken == null || _toToken == null || _toToken!.usdPrice == 0) {
      _toAmount = 0.0;
      return;
    }
    final totalUsd = _fromAmount * _fromToken!.usdPrice;
    _toAmount = totalUsd / _toToken!.usdPrice;
  }

  Future<TransactionItem?> executeSwap() async {
    if (_fromToken == null || _toToken == null || _fromAmount <= 0) return null;

    _isSwapping = true;
    notifyListeners();

    try {
      final newTx = await repository.executeSwap(
        fromToken: _fromToken!,
        toToken: _toToken!,
        fromAmount: _fromAmount,
        toAmount: _toAmount,
      );

      _transactions = await repository.getTransactionHistory();
      _isSwapping = false;
      notifyListeners();
      return newTx;
    } catch (_) {
      _isSwapping = false;
      notifyListeners();
      return null;
    }
  }
}
