import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/responsive_layout.dart';
import 'features/analytics/data/mock_analytics_repository.dart';
import 'features/analytics/presentation/controllers/analytics_controller.dart';
import 'features/navigation/presentation/controllers/navigation_controller.dart';
import 'features/navigation/presentation/screens/app_shell.dart';
import 'features/portfolio/data/mock_portfolio_repository.dart';
import 'features/portfolio/presentation/controllers/portfolio_controller.dart';
import 'features/transact/data/mock_transact_repository.dart';
import 'features/transact/presentation/controllers/transact_controller.dart';
import 'features/wallet/data/mock_wallet_repository.dart';
import 'features/wallet/presentation/controllers/wallet_controller.dart';

/// Root application widget.
class BankingApp extends StatefulWidget {
  const BankingApp({super.key});

  @override
  State<BankingApp> createState() => _BankingAppState();
}

class _BankingAppState extends State<BankingApp> {
  late final WalletController _walletController;
  late final PortfolioController _portfolioController;
  late final AnalyticsController _analyticsController;
  late final TransactController _transactController;
  late final NavigationController _navigationController;

  @override
  void initState() {
    super.initState();
    // Dependency Injection: initialize mock repositories and controllers
    final walletRepo = MockWalletRepository();
    final portfolioRepo = MockPortfolioRepository();
    final analyticsRepo = MockAnalyticsRepository();
    final transactRepo = MockTransactRepository();

    _walletController = WalletController(repository: walletRepo);
    _portfolioController = PortfolioController(repository: portfolioRepo);
    _analyticsController = AnalyticsController(repository: analyticsRepo);
    _transactController = TransactController(repository: transactRepo);
    _navigationController = NavigationController();
  }

  @override
  void dispose() {
    _walletController.dispose();
    _portfolioController.dispose();
    _analyticsController.dispose();
    _transactController.dispose();
    _navigationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Wallet',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: ResponsiveLayout(
        child: AppShell(
          walletController: _walletController,
          portfolioController: _portfolioController,
          analyticsController: _analyticsController,
          transactController: _transactController,
          navigationController: _navigationController,
        ),
      ),
    );
  }
}
