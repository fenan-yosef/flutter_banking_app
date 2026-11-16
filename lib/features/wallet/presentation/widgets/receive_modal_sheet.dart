import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/animated_pressable.dart';

/// Modal sheet displaying QR code and public wallet address for deposits.
class ReceiveModalSheet extends StatelessWidget {
  final String walletName;
  final String publicAddress;
  final String symbol;

  const ReceiveModalSheet({
    super.key,
    required this.walletName,
    required this.publicAddress,
    required this.symbol,
  });

  static Future<void> show(
    BuildContext context, {
    required String walletName,
    required String publicAddress,
    required String symbol,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ReceiveModalSheet(
        walletName: walletName,
        publicAddress: publicAddress,
        symbol: symbol,
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
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.darkButtonBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Receive $symbol',
              style: AppTypography.heroBalance.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 6),
            Text(
              'Deposit into $walletName',
              style: AppTypography.cryptoSub,
            ),
            const SizedBox(height: 24),

            // High-contrast clean QR Code container
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: CustomPaint(
                size: const Size(180, 180),
                painter: _MockQrCodePainter(),
              ),
            ),
            const SizedBox(height: 24),

            // Address pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.darkButtonSurface,
                borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
                border: Border.all(color: AppColors.darkButtonBorder),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      publicAddress,
                      style: AppTypography.syncBadge.copyWith(
                        fontFamily: 'monospace',
                        color: AppColors.textWhite,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedPressable(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: publicAddress));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Address copied to clipboard!'),
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.copy_rounded,
                      color: AppColors.sparklineGreen,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Action button
            SizedBox(
              width: double.infinity,
              child: AnimatedPressable(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.darkButtonBorder,
                    borderRadius: BorderRadius.circular(AppDimens.radiusButton),
                  ),
                  child: Center(
                    child: Text(
                      'Done',
                      style: AppTypography.buttonAction,
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

/// Custom painter rendering a crisp visual QR code pattern.
class _MockQrCodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint blackPaint = Paint()
      ..color = const Color(0xFF16171B)
      ..style = PaintingStyle.fill;

    final double step = size.width / 15;

    // Corner Finder Patterns
    void drawFinder(double x, double y) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, step * 4, step * 4),
          const Radius.circular(6),
        ),
        blackPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x + step * 0.7, y + step * 0.7, step * 2.6, step * 2.6),
          const Radius.circular(4),
        ),
        Paint()..color = Colors.white,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x + step * 1.3, y + step * 1.3, step * 1.4, step * 1.4),
          const Radius.circular(2),
        ),
        blackPaint,
      );
    }

    drawFinder(0, 0);
    drawFinder(size.width - step * 4, 0);
    drawFinder(0, size.height - step * 4);

    // Matrix dots
    final List<List<int>> pattern = [
      [5, 1], [6, 2], [7, 1], [8, 3], [9, 2],
      [1, 5], [2, 6], [3, 7], [4, 5],
      [6, 6], [7, 7], [8, 6], [9, 8], [10, 7],
      [6, 10], [7, 11], [8, 12], [9, 10], [10, 11],
      [11, 5], [12, 6], [13, 7], [14, 5],
      [11, 11], [12, 12], [13, 10], [14, 13],
    ];

    for (final p in pattern) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(p[0] * step, p[1] * step, step * 0.9, step * 0.9),
          const Radius.circular(2),
        ),
        blackPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
