import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/models/analytics_data.dart';

class AssetAllocationCard extends StatelessWidget {
  final List<AssetAllocation> allocations;

  const AssetAllocationCard({
    super.key,
    required this.allocations,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.lightCardSurface,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        border: Border.all(color: AppColors.lightCardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Asset Allocation',
                  style: AppTypography.sectionTitle.copyWith(fontSize: 18),
                ),
              ),
              Text(
                '${allocations.length} Assets',
                style: AppTypography.viewAll,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Multi-segmented bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 12,
              child: Row(
                children: allocations.map((asset) {
                  return Expanded(
                    flex: (asset.percentage * 10).round(),
                    child: Container(
                      color: asset.color,
                      margin: const EdgeInsets.only(right: 2),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Legend & Breakdown
          ...allocations.map((asset) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: asset.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    asset.name,
                    style: AppTypography.assetTitle.copyWith(fontSize: 14),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${asset.percentage.toStringAsFixed(1)}%',
                    style: AppTypography.assetSubtitle.copyWith(fontSize: 12),
                  ),
                  const Spacer(),
                  Text(
                    CurrencyFormatter.formatUsd(asset.usdValue),
                    style: AppTypography.assetPrice.copyWith(fontSize: 14),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
