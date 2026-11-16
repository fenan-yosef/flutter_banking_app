import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/animated_pressable.dart';
import '../../domain/models/transaction_item.dart';
import '../controllers/transact_controller.dart';
import 'swap_confirmation_sheet.dart';

class SwapCard extends StatefulWidget {
  final TransactController controller;

  const SwapCard({
    super.key,
    required this.controller,
  });

  @override
  State<SwapCard> createState() => _SwapCardState();
}

class _SwapCardState extends State<SwapCard> with SingleTickerProviderStateMixin {
  late final TextEditingController _amountController;
  late final AnimationController _flipAnimController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.controller.fromAmount > 0
          ? widget.controller.fromAmount.toString()
          : '0.05',
    );
    _flipAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _flipAnimController.dispose();
    super.dispose();
  }

  void _onFlip() {
    _flipAnimController.forward(from: 0.0);
    widget.controller.reverseTokens();
    _amountController.text = widget.controller.fromAmount.toStringAsFixed(4);
  }

  void _showTokenSelector({
    required BuildContext context,
    required bool isFrom,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkHeroBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                const SizedBox(height: 16),
                Text(
                  isFrom ? 'Select Source Token' : 'Select Destination Token',
                  style: AppTypography.heroBalance.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 16),
                ...widget.controller.tokens.map((token) {
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.darkCardSurface,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: SvgPicture.asset(token.iconAsset),
                    ),
                    title: Text(
                      token.name,
                      style: AppTypography.buttonAction.copyWith(fontSize: 15),
                    ),
                    subtitle: Text(
                      'Balance: ${token.userBalance} ${token.symbol}',
                      style: AppTypography.syncBadge.copyWith(fontSize: 12),
                    ),
                    trailing: Text(
                      CurrencyFormatter.formatUsd(token.usdPrice),
                      style: AppTypography.buttonAction.copyWith(
                        fontSize: 14,
                        color: AppColors.textMutedDark,
                      ),
                    ),
                    onTap: () {
                      if (isFrom) {
                        widget.controller.setFromToken(token);
                      } else {
                        widget.controller.setToToken(token);
                      }
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final fromToken = widget.controller.fromToken;
    final toToken = widget.controller.toToken;
    if (fromToken == null || toToken == null) return const SizedBox.shrink();

    final fromUsd = widget.controller.fromAmount * fromToken.usdPrice;
    final toUsd = widget.controller.toAmount * toToken.usdPrice;

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
                  'Convert & Swap',
                  style: AppTypography.sectionTitle.copyWith(fontSize: 18),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.statusGreenGlow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bolt_rounded, size: 14, color: AppColors.statusGreen),
                    const SizedBox(width: 4),
                    Text(
                      'Zero Slippage',
                      style: AppTypography.syncBadge.copyWith(
                        color: AppColors.statusGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 1. "You Pay" Input Box
          _buildTokenInputBox(
            label: 'You Pay',
            token: fromToken,
            usdEquivalent: fromUsd,
            isEditable: true,
            controller: _amountController,
            onTokenTap: () => _showTokenSelector(context: context, isFrom: true),
            onAmountChanged: (val) {
              final parsed = double.tryParse(val) ?? 0.0;
              widget.controller.setFromAmount(parsed);
            },
          ),

          // Center Flip / Reverse Button
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: AnimatedPressable(
                onTap: _onFlip,
                child: RotationTransition(
                  turns: _flipAnimController,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.darkHeroBackground,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.swap_vert_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 2. "You Receive" Output Box
          _buildTokenInputBox(
            label: 'You Receive',
            token: toToken,
            usdEquivalent: toUsd,
            isEditable: false,
            displayValue: widget.controller.toAmount.toStringAsFixed(4),
            onTokenTap: () => _showTokenSelector(context: context, isFrom: false),
          ),

          const SizedBox(height: 16),

          // Exchange Rate & Gas Banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.lightBackground,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rate',
                      style: AppTypography.assetSubtitle.copyWith(fontSize: 12),
                    ),
                    Text(
                      '1 ${fromToken.symbol} = ${widget.controller.exchangeRate.toStringAsFixed(4)} ${toToken.symbol}',
                      style: AppTypography.assetTitle.copyWith(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Estimated Network Gas',
                      style: AppTypography.assetSubtitle.copyWith(fontSize: 12),
                    ),
                    Text(
                      CurrencyFormatter.formatUsd(widget.controller.estimatedGasFee),
                      style: AppTypography.assetPrice.copyWith(
                        fontSize: 12,
                        color: AppColors.statusGreen,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Review Swap Primary Button
          AnimatedPressable(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => SwapConfirmationSheet(
                  controller: widget.controller,
                ),
              );
            },
            child: Container(
              width: double.infinity,
              height: 54,
              decoration: BoxDecoration(
                color: AppColors.darkHeroBackground,
                borderRadius: BorderRadius.circular(AppDimens.radiusPill),
              ),
              child: Center(
                child: Text(
                  'Review Swap',
                  style: AppTypography.buttonAction.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTokenInputBox({
    required String label,
    required CryptoToken token,
    required double usdEquivalent,
    required bool isEditable,
    TextEditingController? controller,
    String? displayValue,
    required VoidCallback onTokenTap,
    ValueChanged<String>? onAmountChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTypography.assetSubtitle.copyWith(fontSize: 12),
              ),
              Text(
                'Avail: ${token.userBalance} ${token.symbol}',
                style: AppTypography.assetSubtitle.copyWith(fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              // Amount Input
              Expanded(
                child: isEditable
                    ? TextField(
                        controller: controller,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: AppTypography.heroBalance.copyWith(
                          fontSize: 26,
                          color: AppColors.textPrimaryLight,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: onAmountChanged,
                      )
                    : Text(
                        displayValue ?? '0.00',
                        style: AppTypography.heroBalance.copyWith(
                          fontSize: 26,
                          color: AppColors.textPrimaryLight,
                        ),
                      ),
              ),

              // Token Selector Pill
              AnimatedPressable(
                onTap: onTokenTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.lightCardSurface,
                    borderRadius: BorderRadius.circular(AppDimens.radiusPill),
                    border: Border.all(
                      color: AppColors.lightCardBorder,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(token.iconAsset),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        token.symbol,
                        style: AppTypography.assetTitle.copyWith(fontSize: 14),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18,
                        color: AppColors.textSubDark,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '≈ ${CurrencyFormatter.formatUsd(usdEquivalent)}',
            style: AppTypography.assetSubtitle.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
