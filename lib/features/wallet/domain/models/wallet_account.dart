/// Immutable entity representing a wallet account.
class WalletAccount {
  final String id;
  final String name;
  final double fiatBalance;
  final String cryptoSymbol;
  final double cryptoBalance;
  final bool isSynchronized;
  final String publicAddress;

  const WalletAccount({
    required this.id,
    required this.name,
    required this.fiatBalance,
    required this.cryptoSymbol,
    required this.cryptoBalance,
    this.isSynchronized = true,
    required this.publicAddress,
  });

  WalletAccount copyWith({
    String? id,
    String? name,
    double? fiatBalance,
    String? cryptoSymbol,
    double? cryptoBalance,
    bool? isSynchronized,
    String? publicAddress,
  }) {
    return WalletAccount(
      id: id ?? this.id,
      name: name ?? this.name,
      fiatBalance: fiatBalance ?? this.fiatBalance,
      cryptoSymbol: cryptoSymbol ?? this.cryptoSymbol,
      cryptoBalance: cryptoBalance ?? this.cryptoBalance,
      isSynchronized: isSynchronized ?? this.isSynchronized,
      publicAddress: publicAddress ?? this.publicAddress,
    );
  }
}
