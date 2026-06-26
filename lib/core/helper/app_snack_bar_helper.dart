import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

enum AppSnackBarType {
  info,
  success,
  error,
}

class AppSnackBarHelper {
  AppSnackBarHelper._();

  static Color accentColor(AppSnackBarType type) {
    return switch (type) {
      AppSnackBarType.info => AppColors.primary,
      AppSnackBarType.success => AppColors.success,
      AppSnackBarType.error => AppColors.error,
    };
  }

  static IconData icon(AppSnackBarType type) {
    return switch (type) {
      AppSnackBarType.info => Icons.info_outline_rounded,
      AppSnackBarType.success => Icons.check_circle_outline_rounded,
      AppSnackBarType.error => Icons.error_outline_rounded,
    };
  }
}
