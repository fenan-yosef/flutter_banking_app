import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// A GPU-accelerated CustomPainter that draws a smooth cubic Bézier sparkline
/// with an ambient gradient fill and a glowing pulse at the latest price point.
class SparklineChart extends StatelessWidget {
  final List<double> dataPoints;
  final Color lineColor;
  final Color? fillColor;
  final double strokeWidth;
  final bool showGlowDot;

  const SparklineChart({
    super.key,
    required this.dataPoints,
    this.lineColor = AppColors.sparklineGreen,
    this.fillColor,
    this.strokeWidth = 2.0,
    this.showGlowDot = true,
  });

  @override
  Widget build(BuildContext context) {
    if (dataPoints.isEmpty) return const SizedBox.shrink();

    return CustomPaint(
      size: Size.infinite,
      painter: SparklinePainter(
        dataPoints: dataPoints,
        lineColor: lineColor,
        fillColor: fillColor ?? lineColor.withValues(alpha: 0.18),
        strokeWidth: strokeWidth,
        showGlowDot: showGlowDot,
      ),
    );
  }
}

class SparklinePainter extends CustomPainter {
  final List<double> dataPoints;
  final Color lineColor;
  final Color fillColor;
  final double strokeWidth;
  final bool showGlowDot;

  SparklinePainter({
    required this.dataPoints,
    required this.lineColor,
    required this.fillColor,
    required this.strokeWidth,
    required this.showGlowDot,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.length < 2) return;

    final double minVal = dataPoints.reduce((a, b) => a < b ? a : b);
    final double maxVal = dataPoints.reduce((a, b) => a > b ? a : b);
    final double range = (maxVal - minVal) == 0 ? 1.0 : (maxVal - minVal);

    final double paddingY = size.height * 0.15;
    final double usableHeight = size.height - (paddingY * 2);

    // Compute pixel points
    final List<Offset> points = [];
    final double stepX = size.width / (dataPoints.length - 1);

    for (int i = 0; i < dataPoints.length; i++) {
      final double normalizedY = (dataPoints[i] - minVal) / range;
      final double x = i * stepX;
      // Invert Y because canvas coordinate (0,0) is at top-left
      final double y = size.height - paddingY - (normalizedY * usableHeight);
      points.add(Offset(x, y));
    }

    // Build smooth cubic Bézier spline
    final Path strokePath = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 0; i < points.length - 1; i++) {
      final Offset p0 = points[i];
      final Offset p1 = points[i + 1];
      final double controlX = (p0.dx + p1.dx) / 2;
      strokePath.cubicTo(controlX, p0.dy, controlX, p1.dy, p1.dx, p1.dy);
    }

    // Gradient fill underneath the spline
    final Path fillPath = Path.from(strokePath)
      ..lineTo(points.last.dx, size.height)
      ..lineTo(points.first.dx, size.height)
      ..close();

    final Paint fillPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, points.map((p) => p.dy).reduce((a, b) => a < b ? a : b)),
        Offset(0, size.height),
        [
          fillColor,
          fillColor.withValues(alpha: 0.0),
        ],
      )
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // Stroke line
    final Paint linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(strokePath, linePaint);

    // Latest price point glow dot
    if (showGlowDot) {
      final Offset lastPoint = points.last;

      final Paint glowPaint = Paint()
        ..color = lineColor.withValues(alpha: 0.35)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(lastPoint, 5.0, glowPaint);

      final Paint dotPaint = Paint()
        ..color = lineColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(lastPoint, 2.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant SparklinePainter oldDelegate) {
    return oldDelegate.dataPoints != dataPoints ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.fillColor != fillColor;
  }
}
