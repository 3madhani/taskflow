import 'package:flutter/material.dart';
import '../constants/app_breakpoints.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget Function(BuildContext context, BoxConstraints constraints) mobile;
  final Widget Function(BuildContext context, BoxConstraints constraints)? tablet;

  const ResponsiveLayout({
    required this.mobile,
    this.tablet,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth >= AppBreakpoints.tablet && tablet != null) {
        return tablet!(context, constraints);
      }
      return mobile(context, constraints);
    });
  }
}
