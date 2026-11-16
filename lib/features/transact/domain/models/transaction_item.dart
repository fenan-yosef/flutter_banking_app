enum TransactionType { swap, send, receive, buy }

enum TransactionStatus { completed, pending, failed }

class TransactionItem {
  final String id;
  final String title;
  final TransactionType type;
  final double cryptoAmount;
  final String cryptoSymbol;
  final double fiatAmount;
  final DateTime timestamp;
  final TransactionStatus status;
  final String? hash;

  const TransactionItem({
    required this.id,
    required this.title,
    required this.type,
    required this.cryptoAmount,
    required this.cryptoSymbol,
    required this.fiatAmount,
    required this.timestamp,
    required this.status,
    this.hash,
  });
}

class CryptoToken {
  final String symbol;
  final String name;
  final String iconAsset;
  final double usdPrice;
  final double userBalance;

  const CryptoToken({
    required this.symbol,
    required this.name,
    required this.iconAsset,
    required this.usdPrice,
    required this.userBalance,
  });
}
