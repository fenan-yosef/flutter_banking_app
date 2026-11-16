import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/models/analytics_data.dart';

class InteractiveChart extends StatelessWidget {
  final List<ChartPoint> points;
  final ChartPoint? scrubbedPoint;
  final ValueChanged<ChartPoint?> onScrub;

  const InteractiveChart({
    super.key,
    required this.points,
    required this.scrubbedPoint,
    required this.onScrub,
  });

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return const SizedBox(
        height: 180,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.sparklineGreen),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        const height = 180.0;

        return GestureDetector(
          onHorizontalDragStart: (details) => _handleTouch(details.localPosition.dx, width),
          onHorizontalDragUpdate: (details) => _handleTouch(details.localPosition.dx, width),
          onHorizontalDragEnd: (_) => onScrub(null),
          onHorizontalDragCancel: () => onScrub(null),
          onTapDown: (details) => _handleTouch(details.localPosition.dx, width),
          onTapUp: (_) => onScrub(null),
          onTapCancel: () => onScrub(null),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              CustomPaint(
                size: Size(width, height),
                painter: _InteractiveChartPainter(
                  points: points,
                  scrubbedPoint: scrubbedPoint,
                ),
              ),

              // Floating Tooltip Bubble
              if (scrubbedPoint != null) ...[
                Builder(
                  builder: (context) {
                    final index = points.indexOf(scrubbedPoint!);
                    if (index == -1) return const SizedBox.shrink();
                    final stepX = width / (points.length - 1);
                    final posX = (index * stepX).clamp(40.0, width - 40.0);

                    return Positioned(
                      left: posX - 48,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.darkCardSurface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.darkButtonBorder,
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              CurrencyFormatter.formatUsd(scrubbedPoint!.value),
                              style: AppTypography.buttonAction.copyWith(
                                fontSize: 13,
                                color: AppColors.sparklineGreen,
                              ),
                            ),
                            Text(
                              scrubbedPoint!.label,
                              style: AppTypography.syncBadge.copyWith(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  void _handleTouch(double localX, double totalWidth) {
    if (points.isEmpty || totalWidth <= 0) return;
    final clampedX = localX.clamp(0.0, totalWidth);
    final ratio = clampedX / totalWidth;
    final index = (ratio * (points.length - 1)).round().clamp(0, points.length - 1);
    onScrub(points[index]);
  }
}

class _InteractiveChartPainter extends CustomPainter {
  final List<ChartPoint> points;
  final ChartPoint? scrubbedPoint;

  _InteractiveChartPainter({
    required this.points,
    required this.scrubbedPoint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final values = points.map((p) => p.value).toList();
    final minVal = values.reduce(math.min);
    final maxVal = values.reduce(math.max);
    final valRange = (maxVal - minVal) == 0 ? 1.0 : (maxVal - minVal);

    // Provide 20% vertical padding so curve doesn't clip top/bottom
    const topPadding = 32.0;
    const bottomPadding = 16.0;
    final chartHeight = size.height - topPadding - bottomPadding;
    final stepX = size.width / (points.length - 1);

    final pixelPoints = <Offset>[];
    for (int i = 0; i < points.length; i++) {
      final x = i * stepX;
      final normalizedY = (points[i].value - minVal) / valRange;
      final y = size.height - bottomPadding - (normalizedY * chartHeight);
      pixelPoints.add(Offset(x, y));
    }

    // Smooth cubic Bézier spline
    final linePath = Path();
    linePath.moveTo(pixelPoints.first.dx, pixelPoints.first.dy);

    for (int i = 0; i < pixelPoints.length - 1; i++) {
      final p0 = pixelPoints[i];
      final p1 = pixelPoints[i + 1];
      final controlPointX = (p0.dx + p1.dx) / 2;
      linePath.cubicTo(
        controlPointX,
        p0.dy,
        controlPointX,
        p1.dy,
        p1.dx,
        p1.dy,
      );
    }

    // Fill Path with gradient
    final fillPath = Path.from(linePath);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.sparklineGreen.withValues(alpha: 0.28),
          AppColors.sparklineGreen.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // Stroke Path
    final strokePaint = Paint()
      ..color = AppColors.sparklineGreen
      ..strokeWidth = 2.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(linePath, strokePaint);

    // If a point is scrubbed, draw vertical guideline and highlight indicator
    if (scrubbedPoint != null) {
      final scrubIndex = points.indexOf(scrubbedPoint!);
      if (scrubIndex != -1) {
        final targetOffset = pixelPoints[scrubIndex];

        // Vertical dashed guideline
        final dashPaint = Paint()
          ..color = AppColors.textSubDark.withValues(alpha: 0.5)
          ..strokeWidth = 1.2
          ..style = PaintingStyle.stroke;

        canvas.drawLine(
          Offset(targetOffset.dx, topPadding),
          Offset(targetOffset.dx, size.height),
          dashPaint,
        );

        // Outer glow circle
        final glowPaint = Paint()
          ..color = AppColors.sparklineGreen.withValues(alpha: 0.25)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(targetOffset, 8.0, glowPaint);

        // Inner solid circle
        final dotPaint = Paint()
          ..color = AppColors.sparklineGreen
          ..style = PaintingStyle.fill;
        canvas.drawCircle(targetOffset, 4.0, dotPaint);

        // White center dot
        final centerPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;
        canvas.drawCircle(targetOffset, 1.8, centerPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _InteractiveChartPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.scrubbedPoint != scrubbedPoint;
  }
}
