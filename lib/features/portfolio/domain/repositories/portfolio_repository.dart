import '../models/crypto_asset.dart';

/// Abstract contract for portfolio data operations.
abstract class PortfolioRepository {
  Future<List<CryptoAsset>> getAssets({AssetCategory category = AssetCategory.all});
  Future<CryptoAsset?> getFeaturedAsset();
}
