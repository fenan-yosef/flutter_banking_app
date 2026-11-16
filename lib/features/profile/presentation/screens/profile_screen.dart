import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/animated_pressable.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _faceIdEnabled = true;
  bool _twoFactorEnabled = true;
  bool _pushNotifications = true;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: Column(
          children: [
            // 1. Dark Hero Header
            _buildDarkHeroHeader(context),

            const SizedBox(height: 24),

            // 2. Light Body Settings Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Security & Biometrics
                  _buildSettingsSection(
                    title: 'Security & Access',
                    items: [
                      _buildSwitchTile(
                        icon: Icons.fingerprint_rounded,
                        title: 'Biometric Login (Face ID)',
                        subtitle: 'Require Face ID to sign transactions',
                        value: _faceIdEnabled,
                        onChanged: (val) => setState(() => _faceIdEnabled = val),
                      ),
                      const Divider(height: 1, color: AppColors.lightCardBorder),
                      _buildSwitchTile(
                        icon: Icons.security_rounded,
                        title: 'Two-Factor Authentication',
                        subtitle: 'Authenticator app enabled',
                        value: _twoFactorEnabled,
                        onChanged: (val) => setState(() => _twoFactorEnabled = val),
                      ),
                      const Divider(height: 1, color: AppColors.lightCardBorder),
                      _buildNavigationTile(
                        icon: Icons.key_rounded,
                        title: 'Recovery Seed Phrase',
                        subtitle: 'Backed up to iCloud Keychain',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Seed phrase securely stored'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Linked Accounts & Banking
                  _buildSettingsSection(
                    title: 'Linked Financials',
                    items: [
                      _buildNavigationTile(
                        icon: Icons.account_balance_rounded,
                        title: 'JPMorgan Chase •••• 4182',
                        subtitle: 'ACH Primary Deposit Account',
                        trailingText: 'Verified',
                        onTap: () {},
                      ),
                      const Divider(height: 1, color: AppColors.lightCardBorder),
                      _buildNavigationTile(
                        icon: Icons.credit_card_rounded,
                        title: 'Apple Pay & Debit Card',
                        subtitle: 'Instant crypto on-ramp',
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // App Preferences
                  _buildSettingsSection(
                    title: 'Preferences',
                    items: [
                      _buildNavigationTile(
                        icon: Icons.attach_money_rounded,
                        title: 'Default Currency',
                        subtitle: 'United States Dollar (USD \$)',
                        onTap: () {},
                      ),
                      const Divider(height: 1, color: AppColors.lightCardBorder),
                      _buildSwitchTile(
                        icon: Icons.notifications_none_rounded,
                        title: 'Price Alerts & Volatility',
                        subtitle: 'Instant notifications on >5% swings',
                        value: _pushNotifications,
                        onChanged: (val) => setState(() => _pushNotifications = val),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Log Out Button
                  AnimatedPressable(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Logged out of demo wallet session'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppDimens.radiusPill),
                        border: Border.all(color: const Color(0xFFFCA5A5), width: 1),
                      ),
                      child: Center(
                        child: Text(
                          'Sign Out',
                          style: AppTypography.buttonAction.copyWith(
                            color: const Color(0xFFEF4444),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 80 + bottomInset),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDarkHeroHeader(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, topPadding + 16, 20, 28),
      decoration: const BoxDecoration(
        color: AppColors.darkHeroBackground,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppDimens.radiusHeroBottom),
          bottomRight: Radius.circular(AppDimens.radiusHeroBottom),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Profile & Settings',
                  style: AppTypography.heroBalance.copyWith(
                    fontSize: 22,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.darkCardSurface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.darkButtonBorder, width: 1),
                ),
                child: const Icon(
                  Icons.edit_outlined,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // User Avatar with Verified Pill
          Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.darkButtonSurface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.darkButtonBorder, width: 2),
                ),
                child: const Center(
                  child: Icon(
                    Icons.person_rounded,
                    size: 44,
                    color: AppColors.darkActionIcon,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.statusGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 12,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          Text(
            'Alex Vance',
            style: AppTypography.heroBalance.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.darkCardSurface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.darkButtonBorder, width: 1),
                ),
                child: Text(
                  'Tier 3 Pro • VIP',
                  style: AppTypography.syncBadge.copyWith(
                    color: AppColors.bitcoinOrange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.darkCardSurface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Text(
                      '0x71C...49b2',
                      style: AppTypography.syncBadge.copyWith(fontSize: 11),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.copy_rounded, size: 12, color: AppColors.textSubDark),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required List<Widget> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightCardSurface,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        border: Border.all(color: AppColors.lightCardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text(
              title,
              style: AppTypography.sectionTitle.copyWith(fontSize: 15),
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.lightBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: AppColors.textPrimaryLight),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.assetTitle.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTypography.assetSubtitle.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeTrackColor: AppColors.statusGreen,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radiusCard),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.lightBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: AppColors.textPrimaryLight),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.assetTitle.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.assetSubtitle.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
            if (trailingText != null)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Text(
                  trailingText,
                  style: AppTypography.syncBadge.copyWith(
                    color: AppColors.statusGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSubDark,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
