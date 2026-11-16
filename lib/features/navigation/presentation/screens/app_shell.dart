import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../analytics/presentation/controllers/analytics_controller.dart';
import '../../../analytics/presentation/screens/analytics_screen.dart';
import '../../../portfolio/presentation/controllers/portfolio_controller.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../transact/presentation/controllers/transact_controller.dart';
import '../../../transact/presentation/screens/transact_screen.dart';
import '../../../wallet/presentation/controllers/wallet_controller.dart';
import '../../../wallet/presentation/screens/wallet_home_screen.dart';
import '../controllers/navigation_controller.dart';
import '../widgets/floating_capsule_nav.dart';

class AppShell extends StatelessWidget {
  final WalletController walletController;
  final PortfolioController portfolioController;
  final AnalyticsController analyticsController;
  final TransactController transactController;
  final NavigationController navigationController;

  const AppShell({
    super.key,
    required this.walletController,
    required this.portfolioController,
    required this.analyticsController,
    required this.transactController,
    required this.navigationController,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Stack(
        children: [
          // Preserve State with IndexedStack across all 4 tabs
          ListenableBuilder(
            listenable: navigationController,
            builder: (context, _) {
              return IndexedStack(
                index: navigationController.activeTab.index,
                children: [
                  WalletHomeScreen(
                    walletController: walletController,
                    portfolioController: portfolioController,
                  ),
                  AnalyticsScreen(
                    controller: analyticsController,
                  ),
                  TransactScreen(
                    controller: transactController,
                  ),
                  const ProfileScreen(),
                ],
              );
            },
          ),

          // Persistent Floating Capsule Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: bottomInset > 0 ? bottomInset + 8 : 24,
            child: ListenableBuilder(
              listenable: navigationController,
              builder: (context, _) => FloatingCapsuleNav(
                activeTab: navigationController.activeTab,
                onTabChanged: (tab) => navigationController.setTab(tab),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
