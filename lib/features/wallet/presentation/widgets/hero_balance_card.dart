import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/animated_pressable.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../domain/models/wallet_account.dart';
import 'receive_modal_sheet.dart';
import 'send_modal_sheet.dart';
import 'wallet_selector_sheet.dart';

/// Top dark hero card (#16171B) containing balance, quick actions,
/// avatar, notifications, and synchronization status.
class HeroBalanceCard extends StatefulWidget {
  final WalletAccount? account;
  final List<WalletAccount> accounts;
  final bool isRefreshing;
  final ValueChanged<String> onSwitchAccount;
  final VoidCallback onRefresh;
  final Future<void> Function({
    required String recipient,
    required double amount,
    required String symbol,
  })
  onSendFunds;

  const HeroBalanceCard({
    super.key,
    required this.account,
    required this.accounts,
    required this.isRefreshing,
    required this.onSwitchAccount,
    required this.onRefresh,
    required this.onSendFunds,
  });

  @override
  State<HeroBalanceCard> createState() => _HeroBalanceCardState();
}

class _HeroBalanceCardState extends State<HeroBalanceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _spinController;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  void didUpdateWidget(covariant HeroBalanceCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRefreshing && !oldWidget.isRefreshing) {
      _spinController.repeat();
    } else if (!widget.isRefreshing && oldWidget.isRefreshing) {
      _spinController.forward().then((_) => _spinController.reset());
    }
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  void _triggerRefresh() {
    _spinController.forward(from: 0.0);
    widget.onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final account = widget.account;
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.darkHeroBackground,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppDimens.radiusHeroBottom),
          bottomRight: Radius.circular(AppDimens.radiusHeroBottom),
        ),
      ),
      padding: EdgeInsets.fromLTRB(20, topPadding + 10, 20, 26),
      child: Column(
        children: [
          // Top Bar: Avatar on Left, Notification on Right
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Circular Artistic Avatar
              Container(
                width: AppDimens.avatarSize,
                height: AppDimens.avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                ),
                child: ClipOval(
                  child: SvgPicture.asset(AppAssets.avatar, fit: BoxFit.cover),
                ),
              ),

              // Notification Bell with Unread Dot
              AnimatedPressable(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No new notifications'),
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: Container(
                  width: AppDimens.avatarSize,
                  height: AppDimens.avatarSize,
                  decoration: BoxDecoration(
                    color: AppColors.darkButtonSurface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.darkButtonBorder,
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.notifications_none_rounded,
                        color: AppColors.darkActionIcon,
                        size: 20,
                      ),
                      Positioned(
                        top: 10,
                        right: 11,
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Wallet Selector: "Wallet 1 ⌵"
          AnimatedPressable(
            onTap: () {
              if (account != null) {
                WalletSelectorSheet.show(
                  context,
                  accounts: widget.accounts,
                  activeAccountId: account.id,
                  onSelect: widget.onSwitchAccount,
                );
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  account?.name ?? 'Wallet 1',
                  style: AppTypography.walletSelector,
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textMutedDark,
                  size: 18,
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Main Hero Balance: "$2,246"
          Text(
            account != null
                ? CurrencyFormatter.formatFiat(account.fiatBalance)
                : '\$2,246',
            style: AppTypography.heroBalance,
          ),

          const SizedBox(height: 4),

          // Sub-balance & Refresh: "210.43 XMR ↻"
          AnimatedPressable(
            onTap: _triggerRefresh,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  account != null
                      ? CurrencyFormatter.formatCrypto(
                          account.cryptoBalance,
                          account.cryptoSymbol,
                        )
                      : '210.43 XMR',
                  style: AppTypography.cryptoSub,
                ),
                const SizedBox(width: 6),
                AnimatedBuilder(
                  animation: _spinController,
                  builder: (context, child) => Transform.rotate(
                    angle: _spinController.value * 2 * math.pi,
                    child: child,
                  ),
                  child: const Icon(
                    Icons.sync_rounded,
                    color: AppColors.textSubDark,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Action Buttons: [ ↙ Recieve ]  [ + ]  [ ↗ Send ]
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Recieve Button
              AnimatedPressable(
                onTap: () {
                  if (account != null) {
                    ReceiveModalSheet.show(
                      context,
                      walletName: account.name,
                      publicAddress: account.publicAddress,
                      symbol: account.cryptoSymbol,
                    );
                  }
                },
                child: Container(
                  height: AppDimens.actionBtnHeight,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: AppColors.darkButtonSurface,
                    borderRadius: BorderRadius.circular(AppDimens.radiusButton),
                    border: Border.all(
                      color: AppColors.darkButtonBorder,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.south_west_rounded,
                        color: AppColors.textWhite,
                        size: 15,
                      ),
                      const SizedBox(width: 6),
                      Text('Recieve', style: AppTypography.buttonAction),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Center "+" Action Button
              AnimatedPressable(
                onTap: () {
                  if (account != null) {
                    ReceiveModalSheet.show(
                      context,
                      walletName: account.name,
                      publicAddress: account.publicAddress,
                      symbol: account.cryptoSymbol,
                    );
                  }
                },
                child: Container(
                  width: AppDimens.plusBtnSize,
                  height: AppDimens.plusBtnSize,
                  decoration: BoxDecoration(
                    color: AppColors.darkButtonSurface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.darkButtonBorder,
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Send Button
              AnimatedPressable(
                onTap: () {
                  if (account != null) {
                    SendModalSheet.show(
                      context,
                      symbol: account.cryptoSymbol,
                      availableBalance: account.cryptoBalance,
                      onSend: ({required recipient, required amount}) =>
                          widget.onSendFunds(
                            recipient: recipient,
                            amount: amount,
                            symbol: account.cryptoSymbol,
                          ),
                    );
                  }
                },
                child: Container(
                  height: AppDimens.actionBtnHeight,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: AppColors.darkButtonSurface,
                    borderRadius: BorderRadius.circular(AppDimens.radiusButton),
                    border: Border.all(
                      color: AppColors.darkButtonBorder,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.north_east_rounded,
                        color: AppColors.textWhite,
                        size: 15,
                      ),
                      const SizedBox(width: 6),
                      Text('Send', style: AppTypography.buttonAction),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 26),

          // Synchronized Live Pill
          StatusBadge(isSynchronized: account?.isSynchronized ?? true),
        ],
      ),
    );
  }
}
