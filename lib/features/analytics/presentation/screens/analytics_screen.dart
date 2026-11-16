import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/animated_pressable.dart';
import '../../domain/models/analytics_data.dart';
import '../controllers/analytics_controller.dart';
import '../widgets/asset_allocation_card.dart';
import '../widgets/cash_flow_card.dart';
import '../widgets/interactive_chart.dart';
import '../widgets/market_insights_card.dart';

class AnalyticsScreen extends StatefulWidget {
  final AnalyticsController controller;

  const AnalyticsScreen({
    super.key,
    required this.controller,
  });

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.init();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        if (widget.controller.isLoading) {
          return const Scaffold(
            backgroundColor: AppColors.lightBackground,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.darkHeroBackground),
            ),
          );
        }

        final valuation = widget.controller.displayValuation;
        final change = widget.controller.periodAbsoluteChange;
        final pctChange = widget.controller.periodPercentageChange;
        final isPositive = change >= 0;

        return Scaffold(
          backgroundColor: AppColors.lightBackground,
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Dark Hero Header with Interactive Chart
                _buildDarkHeroHeader(
                  context: context,
                  valuation: valuation,
                  change: change,
                  pctChange: pctChange,
                  isPositive: isPositive,
                ),

                const SizedBox(height: 24),

                // 2. Light Body Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Asset Allocation Breakdown
                      if (widget.controller.allocations.isNotEmpty)
                        AssetAllocationCard(
                          allocations: widget.controller.allocations,
                        ),

                      const SizedBox(height: 16),

                      // Cash Flow Card
                      if (widget.controller.cashFlow != null)
                        CashFlowCard(
                          cashFlow: widget.controller.cashFlow!,
                        ),

                      const SizedBox(height: 16),

                      // Market Insights
                      if (widget.controller.insights.isNotEmpty)
                        MarketInsightsCard(
                          insights: widget.controller.insights,
                        ),

                      // Bottom spacing for floating navigation capsule
                      SizedBox(height: 80 + bottomInset),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDarkHeroHeader({
    required BuildContext context,
    required double valuation,
    required double change,
    required double pctChange,
    required bool isPositive,
  }) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.darkHeroBackground,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppDimens.radiusHeroBottom),
          bottomRight: Radius.circular(AppDimens.radiusHeroBottom),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: topPadding + 16),

          // Top Bar: Screen title & Sync pill
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Analytics',
                  style: AppTypography.heroBalance.copyWith(
                    fontSize: 22,
                    letterSpacing: -0.5,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.darkCardSurface,
                    borderRadius: BorderRadius.circular(AppDimens.radiusPill),
                    border: Border.all(
                      color: AppColors.darkButtonBorder,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: AppColors.statusGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Live Track',
                        style: AppTypography.syncBadge.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Total Portfolio Value & Period Change Badge
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Portfolio Net Worth',
                  style: AppTypography.cryptoSub.copyWith(fontSize: 13),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      CurrencyFormatter.formatUsd(valuation),
                      style: AppTypography.heroBalance.copyWith(fontSize: 36),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isPositive
                            ? AppColors.statusGreenGlow
                            : const Color(0x22EF4444),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isPositive
                                ? Icons.arrow_upward_rounded
                                : Icons.arrow_downward_rounded,
                            size: 12,
                            color: isPositive
                                ? AppColors.statusGreen
                                : const Color(0xFFEF4444),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${isPositive ? '+' : ''}${pctChange.toStringAsFixed(1)}%',
                            style: AppTypography.syncBadge.copyWith(
                              color: isPositive
                                  ? AppColors.statusGreen
                                  : const Color(0xFFEF4444),
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Timeframe Pills
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.darkCardSurface,
                borderRadius: BorderRadius.circular(AppDimens.radiusPill),
                border: Border.all(
                  color: AppColors.darkButtonBorder,
                  width: 1,
                ),
              ),
              child: Row(
                children: Timeframe.values.map((tf) {
                  final isSelected = widget.controller.selectedTimeframe == tf;
                  return Expanded(
                    child: AnimatedPressable(
                      onTap: () => widget.controller.setTimeframe(tf),
                      child: Container(
                        height: 38,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.darkButtonSurface : Colors.transparent,
                          borderRadius: BorderRadius.circular(AppDimens.radiusPill),
                          border: isSelected
                              ? Border.all(
                                  color: AppColors.darkButtonBorder,
                                  width: 1,
                                )
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            tf.label,
                            style: AppTypography.buttonAction.copyWith(
                              fontSize: 12,
                              color: isSelected
                                  ? AppColors.textWhite
                                  : AppColors.textSubDark,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Interactive Chart Canvas
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: InteractiveChart(
              points: widget.controller.chartPoints,
              scrubbedPoint: widget.controller.scrubbedPoint,
              onScrub: widget.controller.setScrubbedPoint,
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
