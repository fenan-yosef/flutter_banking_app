import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// Typography hierarchy matching the mockup.
class AppTypography {
  AppTypography._();

  // Hero Card Typography
  static TextStyle heroBalance = GoogleFonts.plusJakartaSans(
    fontSize: 44,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.2,
    color: AppColors.textWhite,
  );

  static TextStyle cryptoSub = GoogleFonts.plusJakartaSans(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.2,
    color: AppColors.textMutedDark,
  );

  static TextStyle walletSelector = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textMutedDark,
    letterSpacing: -0.1,
  );

  static TextStyle buttonAction = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
    letterSpacing: -0.1,
  );

  static TextStyle syncBadge = GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textMutedDark,
    letterSpacing: 0.1,
  );

  // Portfolio Section Typography
  static TextStyle sectionTitle = GoogleFonts.plusJakartaSans(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimaryLight,
    letterSpacing: -0.4,
  );

  static TextStyle viewAll = GoogleFonts.plusJakartaSans(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondaryLight,
  );

  static TextStyle assetTitle = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryLight,
    letterSpacing: -0.2,
  );

  static TextStyle assetSubtitle = GoogleFonts.plusJakartaSans(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.lightTileSubtitle,
  );

  static TextStyle assetPrice = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryLight,
    letterSpacing: -0.3,
  );

  // Featured Dark Card Typography
  static TextStyle featuredPrice = GoogleFonts.plusJakartaSans(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textWhite,
    letterSpacing: -0.3,
  );

  static TextStyle featuredSub = GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textMutedDark,
  );
}
