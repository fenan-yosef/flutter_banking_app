import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/animated_pressable.dart';
import '../controllers/transact_controller.dart';

class SwapConfirmationSheet extends StatefulWidget {
  final TransactController controller;

  const SwapConfirmationSheet({
    super.key,
    required this.controller,
  });

  @override
  State<SwapConfirmationSheet> createState() => _SwapConfirmationSheetState();
}

class _SwapConfirmationSheetState extends State<SwapConfirmationSheet> {
  bool _isConfirming = false;

  Future<void> _handleConfirm() async {
    setState(() => _isConfirming = true);
    final tx = await widget.controller.executeSwap();
    if (!mounted) return;
    setState(() => _isConfirming = false);

    Navigator.pop(context);

    if (tx != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Swapped ${tx.cryptoAmount} ${tx.cryptoSymbol} successfully!'),
          backgroundColor: AppColors.darkHeroBackground,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final fromToken = widget.controller.fromToken!;
    final toToken = widget.controller.toToken!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: AppColors.darkHeroBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.darkButtonBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'Confirm Order',
              style: AppTypography.heroBalance.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 6),
            Text(
              'Review trade parameters before executing on-chain.',
              style: AppTypography.syncBadge.copyWith(fontSize: 13),
            ),
            const SizedBox(height: 20),

            // Trade Summary Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.darkCardSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.darkButtonBorder,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  _buildDetailRow(
                    label: 'Pay',
                    value: '${widget.controller.fromAmount} ${fromToken.symbol}',
                    subValue: CurrencyFormatter.formatUsd(
                      widget.controller.fromAmount * fromToken.usdPrice,
                    ),
                  ),
                  const Divider(color: AppColors.darkButtonBorder, height: 24),
                  _buildDetailRow(
                    label: 'Receive (Est.)',
                    value: '${widget.controller.toAmount.toStringAsFixed(4)} ${toToken.symbol}',
                    subValue: CurrencyFormatter.formatUsd(
                      widget.controller.toAmount * toToken.usdPrice,
                    ),
                    isHighlight: true,
                  ),
                  const Divider(color: AppColors.darkButtonBorder, height: 24),
                  _buildDetailRow(
                    label: 'Slippage Tolerance',
                    value: '${widget.controller.slippageTolerance}%',
                  ),
                  const SizedBox(height: 10),
                  _buildDetailRow(
                    label: 'Network Fee',
                    value: CurrencyFormatter.formatUsd(widget.controller.estimatedGasFee),
                  ),
                  const SizedBox(height: 10),
                  _buildDetailRow(
                    label: 'Liquidity Provider',
                    value: 'Uniswap V3 Auto-Router',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Confirm Button
            AnimatedPressable(
              onTap: _isConfirming ? null : _handleConfirm,
              child: Container(
                width: double.infinity,
                height: 54,
                decoration: BoxDecoration(
                  color: AppColors.sparklineGreen,
                  borderRadius: BorderRadius.circular(AppDimens.radiusPill),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.sparklineGreen.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: _isConfirming
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.black,
                          ),
                        )
                      : Text(
                          'Confirm & Sign',
                          style: AppTypography.buttonAction.copyWith(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    String? subValue,
    bool isHighlight = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.syncBadge.copyWith(fontSize: 13),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: AppTypography.buttonAction.copyWith(
                fontSize: 14,
                color: isHighlight ? AppColors.sparklineGreen : Colors.white,
                fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
            if (subValue != null)
              Text(
                subValue,
                style: AppTypography.syncBadge.copyWith(fontSize: 11),
              ),
          ],
        ),
      ],
    );
  }
}
