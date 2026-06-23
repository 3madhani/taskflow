import 'package:flutter/material.dart';
import '../constants/app_breakpoints.dart';

extension ScreenUtils on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  bool get isMobile => screenWidth < AppBreakpoints.tablet;
  bool get isTablet => screenWidth >= AppBreakpoints.tablet;

  double get horizontalPadding => isTablet ? 32.0 : 16.0;

  int get gridColumns => isTablet ? 2 : 1;

  double get fontScale => isTablet ? 1.15 : 1.0;
}
