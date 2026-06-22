import 'package:flutter/material.dart';
import '../constants/app_breakpoints.dart';

extension ScreenUtils on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  bool get isMobile => screenWidth < AppBreakpoints.tablet;
  bool get isTablet => screenWidth >= AppBreakpoints.tablet;

  /// Fluid padding: 16 on mobile, 32 on tablet
  double get horizontalPadding => isTablet ? 32.0 : 16.0;

  /// Card columns: 1 on mobile, 2 on tablet
  int get gridColumns => isTablet ? 2 : 1;

  /// Font scale factor
  double get fontScale => isTablet ? 1.15 : 1.0;
}
