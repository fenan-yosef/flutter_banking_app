import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/animated_pressable.dart';
import '../../../../core/widgets/sparkline_painter.dart';
import '../../domain/models/crypto_asset.dart';

/// Featured dark card displaying a live sparkline chart, fiat amount,
/// and cryptocurrency holding (e.g. $640.03 / 20.43 XMR).
class FeaturedAssetCard extends StatelessWidget {
  final CryptoAsset asset;
  final VoidCallback? onTap;

  const FeaturedAssetCard({
    super.key,
    required this.asset,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPressable(
      onTap: onTap,
      child: Container(
        width: 134,
        decoration: BoxDecoration(
          color: AppColors.darkCardSurface,
          borderRadius: BorderRadius.circular(AppDimens.radiusCard * 0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Sparkline Line Graph
            SizedBox(
              height: 26,
              width: double.infinity,
              child: SparklineChart(
                dataPoints: asset.sparkline,
                lineColor: AppColors.sparklineGreen,
                strokeWidth: 2.0,
              ),
            ),
            const SizedBox(height: 8),
            // Amount & Subtitle in bottom grouping
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  CurrencyFormatter.formatFiat(asset.fiatValue, showCents: true),
                  style: AppTypography.featuredPrice.copyWith(fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  CurrencyFormatter.formatCrypto(asset.holdings, asset.symbol),
                  style: AppTypography.featuredSub.copyWith(fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
