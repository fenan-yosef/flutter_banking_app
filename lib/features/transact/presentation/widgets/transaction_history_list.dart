import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/animated_pressable.dart';
import '../../domain/models/transaction_item.dart';
import '../controllers/transact_controller.dart';

class TransactionHistoryList extends StatelessWidget {
  final TransactController controller;

  const TransactionHistoryList({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final transactions = controller.transactions;

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
                  'Activity',
                  style: AppTypography.sectionTitle.copyWith(fontSize: 18),
                ),
              ),
              // Filter Pills
              Row(
                children: HistoryFilter.values.map((filter) {
                  final isSelected = controller.filter == filter;
                  final label = filter == HistoryFilter.all
                      ? 'All'
                      : filter == HistoryFilter.swaps
                          ? 'Swaps'
                          : 'Transfers';

                  return Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: AnimatedPressable(
                      onTap: () => controller.setFilter(filter),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.darkHeroBackground
                              : AppColors.lightBackground,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          label,
                          style: AppTypography.syncBadge.copyWith(
                            color: isSelected
                                ? Colors.white
                                : AppColors.textSecondaryLight,
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (transactions.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'No transactions found',
                  style: AppTypography.assetSubtitle,
                ),
              ),
            )
          else
            ...transactions.map((tx) {
              final isPositive = tx.type == TransactionType.receive || tx.type == TransactionType.buy;
              final iconData = tx.type == TransactionType.swap
                  ? Icons.swap_horiz_rounded
                  : tx.type == TransactionType.send
                      ? Icons.arrow_outward_rounded
                      : Icons.arrow_downward_rounded;

              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.lightBackground,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          iconData,
                          size: 20,
                          color: AppColors.textPrimaryLight,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tx.title,
                            style: AppTypography.assetTitle.copyWith(fontSize: 14),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            tx.hash ?? 'Verified on chain',
                            style: AppTypography.assetSubtitle.copyWith(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${isPositive ? '+' : ''}${tx.cryptoAmount} ${tx.cryptoSymbol}',
                          style: AppTypography.assetPrice.copyWith(
                            fontSize: 14,
                            color: isPositive ? AppColors.statusGreen : AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          CurrencyFormatter.formatUsd(tx.fiatAmount),
                          style: AppTypography.assetSubtitle.copyWith(fontSize: 11),
                        ),
                      ],
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
