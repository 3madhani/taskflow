import 'package:flutter/material.dart';
import 'screen_utils.dart';

class ResponsiveValue<T> {
  final T mobile;
  final T? tablet;

  const ResponsiveValue({required this.mobile, this.tablet});

  T resolve(BuildContext context) {
    if (context.isTablet && tablet != null) return tablet as T;
    return mobile;
  }
}
