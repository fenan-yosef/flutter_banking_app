import '../../../../core/constants/app_assets.dart';
import '../../../../core/services/crypto_price_service.dart';
import '../domain/models/transaction_item.dart';

abstract class TransactRepository {
  Future<List<CryptoToken>> getSupportedTokens();
  Future<List<TransactionItem>> getTransactionHistory();
  Future<TransactionItem> executeSwap({
    required CryptoToken fromToken,
    required CryptoToken toToken,
    required double fromAmount,
    required double toAmount,
  });
}

class MockTransactRepository implements TransactRepository {
  final CryptoPriceService _priceService = CryptoPriceService();

  late final List<TransactionItem> _transactions = [
    TransactionItem(
      id: 'tx-1',
      title: 'Swap BTC to ETH',
      type: TransactionType.swap,
      cryptoAmount: 0.12,
      cryptoSymbol: 'BTC',
      fiatAmount: 7726.80, // 0.12 * 64,390
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      status: TransactionStatus.completed,
      hash: '0x8f3c...b412',
    ),
    TransactionItem(
      id: 'tx-2',
      title: 'Received Monero',
      type: TransactionType.receive,
      cryptoAmount: 18.92,
      cryptoSymbol: 'XMR',
      fiatAmount: 2246.00, // 18.92 * 118.70 = 2246.00
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      status: TransactionStatus.completed,
      hash: '0x3a91...e981',
    ),
    TransactionItem(
      id: 'tx-3',
      title: 'Sent Tether (USDT)',
      type: TransactionType.send,
      cryptoAmount: 500.0,
      cryptoSymbol: 'USDT',
      fiatAmount: 500.00,
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      status: TransactionStatus.completed,
      hash: '0x12c4...76f0',
    ),
    TransactionItem(
      id: 'tx-4',
      title: 'Bought Ethereum',
      type: TransactionType.buy,
      cryptoAmount: 1.278,
      cryptoSymbol: 'ETH',
      fiatAmount: 2317.65, // 1.278 * 1813.50
      timestamp: DateTime.now().subtract(const Duration(days: 5)),
      status: TransactionStatus.completed,
      hash: '0x7e29...901a',
    ),
  ];

  @override
  Future<List<CryptoToken>> getSupportedTokens() async {
    await _priceService.fetchLivePrices();

    return [
      CryptoToken(
        symbol: 'BTC',
        name: 'Bitcoin',
        iconAsset: AppAssets.bitcoinIcon,
        usdPrice: _priceService.getPrice('BTC'),
        userBalance: 0.153,
      ),
      CryptoToken(
        symbol: 'ETH',
        name: 'Ethereum',
        iconAsset: AppAssets.ethereumIcon,
        usdPrice: _priceService.getPrice('ETH'),
        userBalance: 1.278,
      ),
      CryptoToken(
        symbol: 'USDT',
        name: 'Tether',
        iconAsset: AppAssets.tetherIcon,
        usdPrice: _priceService.getPrice('USDT'),
        userBalance: 1908.00,
      ),
      CryptoToken(
        symbol: 'XMR',
        name: 'Monero',
        iconAsset: AppAssets.moneroIcon,
        usdPrice: _priceService.getPrice('XMR'),
        userBalance: 18.92,
      ),
    ];
  }

  @override
  Future<List<TransactionItem>> getTransactionHistory() async {
    return List.from(_transactions);
  }

  @override
  Future<TransactionItem> executeSwap({
    required CryptoToken fromToken,
    required CryptoToken toToken,
    required double fromAmount,
    required double toAmount,
  }) async {
    final newTx = TransactionItem(
      id: 'tx-${DateTime.now().millisecondsSinceEpoch}',
      title: 'Swap ${fromToken.symbol} to ${toToken.symbol}',
      type: TransactionType.swap,
      cryptoAmount: fromAmount,
      cryptoSymbol: fromToken.symbol,
      fiatAmount: fromAmount * fromToken.usdPrice,
      timestamp: DateTime.now(),
      status: TransactionStatus.completed,
      hash: '0x${DateTime.now().millisecondsSinceEpoch.toRadixString(16)}...${toToken.symbol.toLowerCase()}',
    );

    _transactions.insert(0, newTx);
    return newTx;
  }
}
