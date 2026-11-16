enum TransactionType { send, receive }

/// Immutable transaction record.
class WalletTransaction {
  final String id;
  final TransactionType type;
  final String assetSymbol;
  final double amount;
  final double fiatAmount;
  final String counterparty;
  final DateTime timestamp;

  const WalletTransaction({
    required this.id,
    required this.type,
    required this.assetSymbol,
    required this.amount,
    required this.fiatAmount,
    required this.counterparty,
    required this.timestamp,
  });
}
