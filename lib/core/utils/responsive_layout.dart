import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Wraps the application to ensure it displays as an edge-to-edge mobile app
/// on phone screens and as an elegant centered mobile mockup on wide desktop browsers.
class ResponsiveLayout extends StatelessWidget {
  final Widget child;

  const ResponsiveLayout({
    super.key,
    required this.child,
  });

  static const double maxMobileWidth = 430.0;
  static const double maxMobileHeight = 920.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 500) {
          // Centered desktop web device frame
          return Scaffold(
            backgroundColor: const Color(0xFF0F1013),
            body: Center(
              child: Container(
                width: maxMobileWidth,
                height: constraints.maxHeight > maxMobileHeight
                    ? maxMobileHeight
                    : constraints.maxHeight,
                margin: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(44),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.6),
                      blurRadius: 40,
                      spreadRadius: 4,
                      offset: const Offset(0, 16),
                    ),
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.04),
                      blurRadius: 1,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: child,
              ),
            ),
          );
        }

        // Native full-screen mobile / simulator
        return child;
      },
    );
  }
}
