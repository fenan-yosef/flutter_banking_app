import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/models/analytics_data.dart';

class MarketInsightsCard extends StatelessWidget {
  final List<MarketInsight> insights;

  const MarketInsightsCard({super.key, required this.insights});

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
            children: [
              // const Icon(
              //   Icons.auto_awesome_rounded,
              //   size: 20,
              //   color: AppColors.bitcoinOrange,
              // ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Intelligence & Insights',
                  style: AppTypography.sectionTitle.copyWith(fontSize: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          ...insights.map((insight) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.darkHeroBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Icon(
                        insight.icon,
                        size: 18,
                        color: AppColors.sparklineGreen,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                insight.title,
                                style: AppTypography.assetTitle.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.statusGreenGlow,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                insight.badge,
                                style: AppTypography.syncBadge.copyWith(
                                  color: AppColors.statusGreen,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          insight.description,
                          style: AppTypography.assetSubtitle.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
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
