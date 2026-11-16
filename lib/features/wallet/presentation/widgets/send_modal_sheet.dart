import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/animated_pressable.dart';

/// Modal sheet for sending cryptocurrency to an address.
class SendModalSheet extends StatefulWidget {
  final String symbol;
  final double availableBalance;
  final Future<void> Function({required String recipient, required double amount}) onSend;

  const SendModalSheet({
    super.key,
    required this.symbol,
    required this.availableBalance,
    required this.onSend,
  });

  static Future<void> show(
    BuildContext context, {
    required String symbol,
    required double availableBalance,
    required Future<void> Function({required String recipient, required double amount}) onSend,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SendModalSheet(
          symbol: symbol,
          availableBalance: availableBalance,
          onSend: onSend,
        ),
      ),
    );
  }

  @override
  State<SendModalSheet> createState() => _SendModalSheetState();
}

class _SendModalSheetState extends State<SendModalSheet> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _addressController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _handleSend() async {
    final address = _addressController.text.trim();
    final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;

    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a recipient address.')),
      );
      return;
    }

    if (amount <= 0 || amount > widget.availableBalance) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid amount up to ${widget.availableBalance} ${widget.symbol}.')),
      );
      return;
    }

    setState(() => _isSending = true);

    try {
      await widget.onSend(recipient: address, amount: amount);
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.darkCardSurface,
            content: Text(
              'Successfully sent $amount ${widget.symbol}!',
              style: const TextStyle(color: AppColors.statusGreen),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
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
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: SafeArea(
        top: false,
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
            const SizedBox(height: 20),
            Text(
              'Send ${widget.symbol}',
              style: AppTypography.heroBalance.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 16),

            // Recipient Input
            Text('Recipient Address', style: AppTypography.syncBadge),
            const SizedBox(height: 8),
            TextField(
              controller: _addressController,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Enter public ${widget.symbol} address',
                hintStyle: const TextStyle(color: AppColors.textMutedDark, fontSize: 13),
                filled: true,
                fillColor: AppColors.darkButtonSurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
                  borderSide: const BorderSide(color: AppColors.darkButtonBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
                  borderSide: const BorderSide(color: AppColors.darkButtonBorder),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 16),

            // Amount Input
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Amount', style: AppTypography.syncBadge),
                Text(
                  'Available: ${widget.availableBalance.toStringAsFixed(2)} ${widget.symbol}',
                  style: AppTypography.syncBadge.copyWith(color: AppColors.textSubDark),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: '0.00',
                hintStyle: const TextStyle(color: AppColors.textMutedDark),
                suffixIcon: TextButton(
                  onPressed: () {
                    _amountController.text = widget.availableBalance.toString();
                  },
                  child: const Text('MAX', style: TextStyle(color: AppColors.sparklineGreen, fontWeight: FontWeight.bold)),
                ),
                filled: true,
                fillColor: AppColors.darkButtonSurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
                  borderSide: const BorderSide(color: AppColors.darkButtonBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
                  borderSide: const BorderSide(color: AppColors.darkButtonBorder),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 24),

            // Send Button
            SizedBox(
              width: double.infinity,
              child: AnimatedPressable(
                onTap: _isSending ? null : _handleSend,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: AppColors.sparklineGreen,
                    borderRadius: BorderRadius.circular(AppDimens.radiusButton),
                  ),
                  child: Center(
                    child: _isSending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        : Text(
                            'Confirm & Send',
                            style: AppTypography.buttonAction.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
