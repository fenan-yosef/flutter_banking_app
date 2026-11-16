import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_banking_app/features/portfolio/data/mock_portfolio_repository.dart';
import 'package:flutter_banking_app/features/portfolio/domain/models/crypto_asset.dart';
import 'package:flutter_banking_app/features/portfolio/presentation/controllers/portfolio_controller.dart';

void main() {
  group('PortfolioController', () {
    late MockPortfolioRepository repo;
    late PortfolioController controller;

    setUp(() {
      repo = MockPortfolioRepository();
      controller = PortfolioController(repository: repo);
    });

    test('initializes with assets and featured asset', () async {
      await controller.init();

      expect(controller.isLoading, isFalse);
      expect(controller.featuredAsset?.name, 'Monero');
      expect(controller.featuredAsset?.fiatValue, closeTo(2245.80, 50.0));
      expect(controller.featuredAsset?.holdings, 18.92);
      expect(controller.assets.length, 4);
    });

    test('filters assets by category', () async {
      await controller.init();
      await controller.setCategory(AssetCategory.crypto);

      expect(controller.activeCategory, AssetCategory.crypto);
      expect(controller.assets.every((a) => a.category == AssetCategory.crypto), isTrue);
    });
  });
}
