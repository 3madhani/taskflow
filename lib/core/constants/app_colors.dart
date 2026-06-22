import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color(0xFF3D5AFE); // deep indigo
  static const Color secondary = Color(0xFF00BFA5); // teal

  // Light theme
  static const Color backgroundLight = Color(0xFFF8F9FF);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF1A1A2E);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color borderLight = Color(0xFFE2E8F0);

  // Dark theme
  static const Color backgroundDark = Color(0xFF0F0F1A);
  static const Color surfaceDark = Color(0xFF1E1E2E);
  static const Color textPrimaryDark = Color(0xFFF1F1F8);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
  static const Color borderDark = Color(0xFF2D2D44);

  // Semantic (same in both themes)
  static const Color error = Color(0xFFFF5252);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);

  // Task status
  static const Color statusPending = Color(0xFFFF9800);
  static const Color statusInProgress = Color(0xFF2196F3);
  static const Color statusDone = Color(0xFF4CAF50);

  // Task priority
  static const Color priorityLow = Color(0xFF4CAF50);
  static const Color priorityMedium = Color(0xFFFF9800);
  static const Color priorityHigh = Color(0xFFF44336);

  // Project status
  static const Color statusActive = Color(0xFF4CAF50);
  static const Color statusOnHold = Color(0xFFFF9800);
  static const Color statusCompleted = Color(0xFF2196F3);
}
