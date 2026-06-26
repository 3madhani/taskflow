import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

const _indicatorPadding = 6.0;
const _navBarHeight = 64.0;
const _navBarRadius = 28.0;

class AnimatedShellNavBar extends StatelessWidget {
  static const _destinations = [
    _ShellDestination(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      label: 'Projects',
    ),
    _ShellDestination(
      icon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
      label: 'Profile',
    ),
  ];
  final int currentIndex;

  final ValueChanged<int> onDestinationSelected;

  const AnimatedShellNavBar({
    required this.currentIndex,
    required this.onDestinationSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;
    final surfaceColor = isDark
        ? AppColors.surfaceDark.withValues(alpha: 0.78)
        : Colors.white.withValues(alpha: 0.88);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.10)
        : AppColors.borderLight.withValues(alpha: 0.95);
    final shadowColor = isDark
        ? Colors.black.withValues(alpha: 0.32)
        : AppColors.primary.withValues(alpha: 0.10);

    return ClipRRect(
      borderRadius: BorderRadius.circular(_navBarRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(_navBarRadius),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 28,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: SizedBox(
            height: _navBarHeight,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = constraints.maxWidth / _destinations.length;
                final indicatorLeft =
                    currentIndex.clamp(0, _destinations.length - 1) * itemWidth;

                return Stack(
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 340),
                      curve: Curves.easeOutCubic,
                      left: indicatorLeft + _indicatorPadding,
                      top: _indicatorPadding,
                      bottom: _indicatorPadding,
                      width: itemWidth - (_indicatorPadding * 2),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.primary.withValues(
                                alpha: isDark ? 0.28 : 0.16,
                              ),
                              AppColors.secondary.withValues(
                                alpha: isDark ? 0.20 : 0.12,
                              ),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: colorScheme.primary.withValues(
                              alpha: isDark ? 0.28 : 0.18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        for (var index = 0;
                            index < _destinations.length;
                            index++)
                          Expanded(
                            child: _AnimatedShellNavItem(
                              destination: _destinations[index],
                              isSelected: currentIndex == index,
                              onTap: () => onDestinationSelected(index),
                            ),
                          ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedShellNavItem extends StatelessWidget {
  final _ShellDestination destination;
  final bool isSelected;
  final VoidCallback onTap;

  const _AnimatedShellNavItem({
    required this.destination,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final selectedColor = isDark ? Colors.white : AppColors.textPrimaryLight;
    final unselectedColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Semantics(
      button: true,
      selected: isSelected,
      label: destination.label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              style: theme.textTheme.labelMedium!.copyWith(
                color: isSelected ? selectedColor : unselectedColor,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                letterSpacing: 0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedScale(
                    scale: isSelected ? 1.08 : 1.0,
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutBack,
                    child: Icon(
                      isSelected ? destination.selectedIcon : destination.icon,
                      color: isSelected ? selectedColor : unselectedColor,
                      size: 22,
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    width: isSelected ? 8 : 6,
                  ),
                  Text(destination.label),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ShellDestination {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _ShellDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}
