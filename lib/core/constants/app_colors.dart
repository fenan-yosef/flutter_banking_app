import 'package:flutter/material.dart';

/// Design tokens and color constants matching the dark/light design mockup.
class AppColors {
  AppColors._();

  // Dark Hero Container & Cards
  static const Color darkHeroBackground = Color(0xFF16171B);
  static const Color darkCardSurface    = Color(0xFF202126);
  static const Color darkButtonSurface  = Color(0xFF222328);
  static const Color darkButtonBorder   = Color(0xFF2E2F36);
  static const Color darkNavBackground  = Color(0xFF18191D);
  static const Color darkActionIcon     = Color(0xFFE4E4E7);

  // Light Bottom Section & Cards
  static const Color lightBackground    = Color(0xFFF7F8FA);
  static const Color lightCardSurface   = Color(0xFFFFFFFF);
  static const Color lightCardBorder    = Color(0xFFEAECEF);
  static const Color lightTileSubtitle  = Color(0xFF71717A);

  // Status & Brand Accents
  static const Color statusGreen        = Color(0xFF22C55E);
  static const Color statusGreenGlow    = Color(0x3322C55E);
  static const Color bitcoinOrange      = Color(0xFFF7931A);
  static const Color tetherTeal         = Color(0xFF26A17B);
  static const Color ethereumViolet     = Color(0xFF627EEA);
  static const Color moneroOrange       = Color(0xFFFF6600);

  // Text Colors
  static const Color textWhite          = Color(0xFFFFFFFF);
  static const Color textMutedDark      = Color(0xFFA1A1AA);
  static const Color textSubDark        = Color(0xFF71717A);
  static const Color textPrimaryLight   = Color(0xFF111114);
  static const Color textSecondaryLight = Color(0xFF71717A);

  // Sparkline Chart Colors
  static const Color sparklineGreen     = Color(0xFF4ADE80);
  static const Color sparklineGreenFill = Color(0x224ADE80);
}
