import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../theme/app_typography.dart';

/// The live "• Synchronized" badge with a soft pulsating green LED indicator.
class StatusBadge extends StatefulWidget {
  final String label;
  final bool isSynchronized;

  const StatusBadge({
    super.key,
    this.label = 'Synchronized',
    this.isSynchronized = true,
  });

  @override
  State<StatusBadge> createState() => _StatusBadgeState();
}

class _StatusBadgeState extends State<StatusBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.darkButtonSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.darkButtonBorder.withValues(alpha: 0.5),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Container(
                width: 6.5,
                height: 6.5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.isSynchronized
                      ? AppColors.statusGreen
                      : Colors.orangeAccent,
                  boxShadow: widget.isSynchronized
                      ? [
                          BoxShadow(
                            color: AppColors.statusGreen.withValues(
                              alpha: 0.6 * _glowAnimation.value,
                            ),
                            blurRadius: 6,
                            spreadRadius: 1.5,
                          ),
                        ]
                      : null,
                ),
              );
            },
          ),
          const SizedBox(width: 7),
          Text(
            widget.label,
            style: AppTypography.syncBadge,
          ),
        ],
      ),
    );
  }
}
