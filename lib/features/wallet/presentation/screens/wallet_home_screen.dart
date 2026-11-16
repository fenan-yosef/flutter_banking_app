import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../navigation/presentation/controllers/navigation_controller.dart';
import '../../../navigation/presentation/widgets/floating_capsule_nav.dart';
import '../../../portfolio/presentation/controllers/portfolio_controller.dart';
import '../../../portfolio/presentation/widgets/crypto_asset_tile.dart';
import '../../../portfolio/presentation/widgets/featured_asset_card.dart';
import '../../../portfolio/presentation/widgets/portfolio_header.dart';
import '../controllers/wallet_controller.dart';
import '../widgets/hero_balance_card.dart';

/// Main screen of the Crypto Wallet & Banking App.
class WalletHomeScreen extends StatefulWidget {
  final WalletController walletController;
  final PortfolioController portfolioController;
  final NavigationController? navigationController;

  const WalletHomeScreen({
    super.key,
    required this.walletController,
    required this.portfolioController,
    this.navigationController,
  });

  @override
  State<WalletHomeScreen> createState() => _WalletHomeScreenState();
}

class _WalletHomeScreenState extends State<WalletHomeScreen> {
  @override
  void initState() {
    super.initState();
    widget.walletController.init();
    widget.portfolioController.init();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Stack(
        children: [
          // Scrollable Body Content
          ListenableBuilder(
            listenable: Listenable.merge([
              widget.walletController,
              widget.portfolioController,
            ]),
            builder: (context, _) {
              if (widget.walletController.isLoading ||
                  widget.portfolioController.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.darkHeroBackground,
                  ),
                );
              }

              final wallet = widget.walletController.activeAccount;
              final featuredAsset = widget.portfolioController.featuredAsset;
              final assets = widget.portfolioController.assets;

              // Separate first asset for the split top row
              final firstAsset = assets.isNotEmpty
                  ? assets.firstWhere(
                      (a) => !a.isFeatured,
                      orElse: () => assets.first,
                    )
                  : null;
              final remainingAssets = assets
                  .where((a) => !a.isFeatured && a != firstAsset)
                  .toList();

              return RefreshIndicator(
                onRefresh: widget.walletController.refresh,
                color: AppColors.sparklineGreen,
                backgroundColor: AppColors.darkCardSurface,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Hero Card
                      HeroBalanceCard(
                        account: wallet,
                        accounts: widget.walletController.accounts,
                        isRefreshing: widget.walletController.isRefreshing,
                        onSwitchAccount: widget.walletController.switchAccount,
                        onRefresh: widget.walletController.refresh,
                        onSendFunds: widget.walletController.sendFunds,
                      ),

                      const SizedBox(height: 24),

                      // Portfolio Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Section Header ("Portfolio", "View all ⌵")
                            PortfolioHeader(
                              activeCategory:
                                  widget.portfolioController.activeCategory,
                              onSelectCategory:
                                  widget.portfolioController.setCategory,
                            ),

                            const SizedBox(height: 16),

                            // Row 1: Featured Sparkline Card + Bitcoin Card
                            if (featuredAsset != null && firstAsset != null) ...[
                              IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    FeaturedAssetCard(asset: featuredAsset),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: CryptoAssetTile(
                                        asset: firstAsset,
                                        hasMarginBottom: false,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                            ] else if (firstAsset != null) ...[
                              CryptoAssetTile(asset: firstAsset),
                            ],

                            // Remaining Portfolio Cards (Tether, Ethereum)
                            ...remainingAssets.map(
                              (asset) => CryptoAssetTile(asset: asset),
                            ),

                            // Extra bottom padding to ensure content isn't obscured by floating nav
                            SizedBox(height: 80 + bottomInset),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Floating Dark Capsule Navigation Bar (when used standalone)
          if (widget.navigationController != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: bottomInset > 0 ? bottomInset + 8 : 24,
              child: ListenableBuilder(
                listenable: widget.navigationController!,
                builder: (context, _) => FloatingCapsuleNav(
                  activeTab: widget.navigationController!.activeTab,
                  onTabChanged: (tab) {
                    widget.navigationController!.setTab(tab);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
