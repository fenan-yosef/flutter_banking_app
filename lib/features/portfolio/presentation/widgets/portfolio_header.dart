import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/models/crypto_asset.dart';

/// Section header with title and interactive filter menu.
class PortfolioHeader extends StatelessWidget {
  final AssetCategory activeCategory;
  final ValueChanged<AssetCategory> onSelectCategory;

  const PortfolioHeader({
    super.key,
    required this.activeCategory,
    required this.onSelectCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Portfolio',
          style: AppTypography.sectionTitle,
        ),
        PopupMenuButton<AssetCategory>(
          initialValue: activeCategory,
          onSelected: onSelectCategory,
          color: AppColors.darkCardSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.darkButtonBorder),
          ),
          child: Row(
            children: [
              Text(
                activeCategory == AssetCategory.all
                    ? 'View all'
                    : activeCategory.name.toUpperCase(),
                style: AppTypography.viewAll,
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.textSecondaryLight,
                size: 18,
              ),
            ],
          ),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: AssetCategory.all,
              child: Text('All Assets', style: TextStyle(color: Colors.white, fontSize: 13)),
            ),
            const PopupMenuItem(
              value: AssetCategory.crypto,
              child: Text('Cryptocurrencies', style: TextStyle(color: Colors.white, fontSize: 13)),
            ),
            const PopupMenuItem(
              value: AssetCategory.fiat,
              child: Text('Fiat Currencies', style: TextStyle(color: Colors.white, fontSize: 13)),
            ),
          ],
        ),
      ],
    );
  }
}
