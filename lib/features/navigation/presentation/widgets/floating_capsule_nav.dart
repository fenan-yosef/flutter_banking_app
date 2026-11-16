import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/widgets/animated_pressable.dart';
import '../controllers/navigation_controller.dart';

/// Floating capsule navigation bar (#18191D) floating above the bottom edge.
class FloatingCapsuleNav extends StatelessWidget {
  final NavTab activeTab;
  final ValueChanged<NavTab> onTabChanged;

  const FloatingCapsuleNav({
    super.key,
    required this.activeTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimens.bottomNavHeight,
      margin: const EdgeInsets.symmetric(horizontal: 56),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.darkNavBackground,
        borderRadius: BorderRadius.circular(AppDimens.radiusPill),
        border: Border.all(
          color: AppColors.darkButtonBorder.withValues(alpha: 0.8),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 24,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 1. Wallet / Home Tab
          _buildNavItem(
            tab: NavTab.wallet,
            icon: Icons.account_balance_wallet_rounded,
          ),

          // 2. Analytics / Bar Chart Tab
          _buildNavItem(
            tab: NavTab.analytics,
            icon: Icons.bar_chart_rounded,
          ),

          // 3. Transact / Dollar Currency Tab
          _buildNavItem(
            tab: NavTab.transact,
            icon: Icons.monetization_on_outlined,
          ),

          // 4. User Profile Tab
          _buildNavItem(
            tab: NavTab.profile,
            icon: Icons.person_outline_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required NavTab tab,
    required IconData icon,
  }) {
    final bool isSelected = activeTab == tab;

    return AnimatedPressable(
      onTap: () => onTabChanged(tab),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.darkButtonSurface : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            icon,
            size: 22,
            color: isSelected ? Colors.white : AppColors.textSubDark,
          ),
        ),
      ),
    );
  }
}
