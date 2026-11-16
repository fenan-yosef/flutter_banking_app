import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/models/analytics_data.dart';

class CashFlowCard extends StatelessWidget {
  final CashFlowSummary cashFlow;

  const CashFlowCard({
    super.key,
    required this.cashFlow,
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
                  'Cash Flow & Savings',
                  style: AppTypography.sectionTitle.copyWith(fontSize: 18),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.statusGreenGlow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '+${(cashFlow.savingsRate * 100).toStringAsFixed(0)}% Saved',
                  style: AppTypography.syncBadge.copyWith(
                    color: AppColors.statusGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          Row(
            children: [
              // Income Box
              Expanded(
                child: _buildMetricTile(
                  label: 'Total Inflow',
                  amount: cashFlow.income,
                  icon: Icons.arrow_downward_rounded,
                  iconColor: AppColors.statusGreen,
                  backgroundColor: AppColors.statusGreenGlow,
                ),
              ),
              const SizedBox(width: 12),
              // Spending Box
              Expanded(
                child: _buildMetricTile(
                  label: 'Total Outflow',
                  amount: cashFlow.spending,
                  icon: Icons.arrow_upward_rounded,
                  iconColor: const Color(0xFFEF4444),
                  backgroundColor: const Color(0x22EF4444),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Net Saved Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.lightBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Net Saved this month',
                    style: AppTypography.assetSubtitle.copyWith(fontSize: 13),
                  ),
                ),
                Text(
                  '+${CurrencyFormatter.formatUsd(cashFlow.netSavings)}',
                  style: AppTypography.assetPrice.copyWith(
                    color: AppColors.statusGreen,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required double amount,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 14, color: iconColor),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.assetSubtitle.copyWith(fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            CurrencyFormatter.formatUsd(amount),
            style: AppTypography.assetPrice.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
