import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/animated_pressable.dart';
import '../controllers/transact_controller.dart';
import '../widgets/swap_card.dart';
import '../widgets/transaction_history_list.dart';

class TransactScreen extends StatefulWidget {
  final TransactController controller;

  const TransactScreen({
    super.key,
    required this.controller,
  });

  @override
  State<TransactScreen> createState() => _TransactScreenState();
}

class _TransactScreenState extends State<TransactScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.init();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        if (widget.controller.isLoading) {
          return const Scaffold(
            backgroundColor: AppColors.lightBackground,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.darkHeroBackground),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.lightBackground,
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Dark Hero Header
                _buildDarkHeroHeader(context),

                const SizedBox(height: 24),

                // 2. Light Body Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Swap Card Widget
                      SwapCard(controller: widget.controller),

                      const SizedBox(height: 16),

                      // Transaction History Ledger
                      TransactionHistoryList(controller: widget.controller),

                      // Bottom spacing for floating navigation capsule
                      SizedBox(height: 80 + bottomInset),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDarkHeroHeader(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, topPadding + 16, 20, 24),
      decoration: const BoxDecoration(
        color: AppColors.darkHeroBackground,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppDimens.radiusHeroBottom),
          bottomRight: Radius.circular(AppDimens.radiusHeroBottom),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Transact',
                style: AppTypography.heroBalance.copyWith(
                  fontSize: 22,
                  letterSpacing: -0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.darkCardSurface,
                  borderRadius: BorderRadius.circular(AppDimens.radiusPill),
                  border: Border.all(
                    color: AppColors.darkButtonBorder,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.shield_outlined,
                      size: 14,
                      color: AppColors.sparklineGreen,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'DEX Connected',
                      style: AppTypography.syncBadge.copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Transact Modes: Swap, Send, Deposit
          Container(
            height: 42,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: AppColors.darkCardSurface,
              borderRadius: BorderRadius.circular(AppDimens.radiusPill),
              border: Border.all(
                color: AppColors.darkButtonBorder,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                _buildModeTab('Swap / Convert', TransactMode.swap),
                _buildModeTab('Transfer', TransactMode.send),
                _buildModeTab('Deposit', TransactMode.buy),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeTab(String label, TransactMode mode) {
    final isSelected = widget.controller.mode == mode;

    return Expanded(
      child: AnimatedPressable(
        onTap: () => widget.controller.setMode(mode),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppColors.darkButtonSurface : Colors.transparent,
            borderRadius: BorderRadius.circular(AppDimens.radiusPill),
            border: isSelected
                ? Border.all(color: AppColors.darkButtonBorder, width: 1)
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: AppTypography.buttonAction.copyWith(
                fontSize: 12,
                color: isSelected ? Colors.white : AppColors.textSubDark,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
