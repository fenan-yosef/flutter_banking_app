import 'package:flutter/material.dart';
import '../../domain/models/crypto_asset.dart';
import '../../domain/repositories/portfolio_repository.dart';

/// Reactive controller managing portfolio assets and filtering.
class PortfolioController extends ChangeNotifier {
  final PortfolioRepository repository;

  PortfolioController({required this.repository});

  List<CryptoAsset> _assets = [];
  CryptoAsset? _featuredAsset;
  AssetCategory _activeCategory = AssetCategory.all;
  bool _isLoading = true;

  List<CryptoAsset> get assets => _assets;
  CryptoAsset? get featuredAsset => _featuredAsset;
  AssetCategory get activeCategory => _activeCategory;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    _featuredAsset = await repository.getFeaturedAsset();
    _assets = await repository.getAssets(category: _activeCategory);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> setCategory(AssetCategory category) async {
    if (_activeCategory == category) return;
    _activeCategory = category;
    _assets = await repository.getAssets(category: _activeCategory);
    notifyListeners();
  }
}
