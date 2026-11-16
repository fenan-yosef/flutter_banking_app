import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/animated_pressable.dart';
import '../../domain/models/wallet_account.dart';

/// Modal sheet for switching between wallets.
class WalletSelectorSheet extends StatelessWidget {
  final List<WalletAccount> accounts;
  final String activeAccountId;
  final ValueChanged<String> onSelect;

  const WalletSelectorSheet({
    super.key,
    required this.accounts,
    required this.activeAccountId,
    required this.onSelect,
  });

  static Future<void> show(
    BuildContext context, {
    required List<WalletAccount> accounts,
    required String activeAccountId,
    required ValueChanged<String> onSelect,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => WalletSelectorSheet(
        accounts: accounts,
        activeAccountId: activeAccountId,
        onSelect: onSelect,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkHeroBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(
          top: BorderSide(color: AppColors.darkButtonBorder, width: 1),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.darkButtonBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Select Wallet',
              style: AppTypography.heroBalance.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 16),
            ...accounts.map((account) {
              final isSelected = account.id == activeAccountId;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AnimatedPressable(
                  onTap: () {
                    onSelect(account.id);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.darkCardSurface
                          : AppColors.darkButtonSurface,
                      borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.sparklineGreen.withValues(alpha: 0.5)
                            : AppColors.darkButtonBorder,
                        width: isSelected ? 1.5 : 0.8,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.sparklineGreen.withValues(alpha: 0.15)
                                : AppColors.darkButtonBorder,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.account_balance_wallet_rounded,
                            color: isSelected
                                ? AppColors.sparklineGreen
                                : AppColors.textMutedDark,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                account.name,
                                style: AppTypography.assetTitle.copyWith(
                                  color: AppColors.textWhite,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${CurrencyFormatter.formatCrypto(account.cryptoBalance, account.cryptoSymbol)} (${CurrencyFormatter.formatFiat(account.fiatBalance)})',
                                style: AppTypography.assetSubtitle.copyWith(
                                  color: AppColors.textMutedDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.sparklineGreen,
                            size: 22,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
