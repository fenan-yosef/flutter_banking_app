import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/animated_pressable.dart';
import '../../../../core/widgets/sparkline_painter.dart';
import '../../domain/models/crypto_asset.dart';

/// Clean rounded asset tile for the portfolio list matching the design mockup.
class CryptoAssetTile extends StatefulWidget {
  final CryptoAsset asset;
  final bool hasMarginBottom;

  const CryptoAssetTile({
    super.key,
    required this.asset,
    this.hasMarginBottom = true,
  });

  @override
  State<CryptoAssetTile> createState() => _CryptoAssetTileState();
}

class _CryptoAssetTileState extends State<CryptoAssetTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final asset = widget.asset;

    return AnimatedPressable(
      onTap: () {
        setState(() => _isExpanded = !_isExpanded);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(bottom: widget.hasMarginBottom ? 12 : 0),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.lightCardSurface,
          borderRadius: BorderRadius.circular(AppDimens.radiusCard * 0.8),
          border: Border.all(
            color: _isExpanded
                ? AppColors.sparklineGreen.withValues(alpha: 0.4)
                : AppColors.lightCardBorder,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                // Circular Crypto Emblem
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: asset.brandColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(2),
                  child: ClipOval(
                    child: SvgPicture.asset(
                      asset.iconPath,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Name & Crypto Holding
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        asset.name,
                        style: AppTypography.assetTitle.copyWith(fontSize: 15),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        CurrencyFormatter.formatCrypto(asset.holdings, asset.symbol),
                        style: AppTypography.assetSubtitle.copyWith(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Fiat Value
                Text(
                  CurrencyFormatter.formatFiat(asset.fiatValue),
                  style: AppTypography.assetPrice.copyWith(fontSize: 15),
                ),
              ],
            ),

            // Expandable chart details when tapped
            if (_isExpanded) ...[
              const SizedBox(height: 16),
              const Divider(color: AppColors.lightCardBorder, height: 1),
              const SizedBox(height: 12),
              SizedBox(
                height: 44,
                child: Row(
                  children: [
                    Expanded(
                      child: SparklineChart(
                        dataPoints: asset.sparkline,
                        lineColor: asset.isPositive ? AppColors.statusGreen : Colors.redAccent,
                        strokeWidth: 2.0,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: (asset.isPositive ? AppColors.statusGreen : Colors.redAccent).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${asset.isPositive ? '+' : ''}${asset.change24h}%',
                        style: TextStyle(
                          color: asset.isPositive ? AppColors.statusGreen : Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
