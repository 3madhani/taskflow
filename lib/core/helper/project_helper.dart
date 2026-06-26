import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../enums/app_enums.dart';

class ProjectHelper {
  ProjectHelper._();

  static Color priorityColor(ProjectPriority priority) {
    return switch (priority) {
      ProjectPriority.low => AppColors.priorityLow,
      ProjectPriority.medium => AppColors.priorityMedium,
      ProjectPriority.high => AppColors.priorityHigh,
    };
  }

  static ProjectPriority priorityFromValue(String priority) {
    return switch (priority) {
      'low' => ProjectPriority.low,
      'high' => ProjectPriority.high,
      _ => ProjectPriority.medium,
    };
  }

  static String priorityLabel(ProjectPriority priority) {
    return switch (priority) {
      ProjectPriority.low => 'Low',
      ProjectPriority.medium => 'Medium',
      ProjectPriority.high => 'High',
    };
  }

  static String priorityValue(ProjectPriority priority) {
    return priority.name;
  }

  static IconData priorityIcon(ProjectPriority priority) {
    return switch (priority) {
      ProjectPriority.low => Icons.arrow_downward_rounded,
      ProjectPriority.medium => Icons.remove_rounded,
      ProjectPriority.high => Icons.arrow_upward_rounded,
    };
  }

  static Color statusColor(ProjectStatus status) {
    return switch (status) {
      ProjectStatus.active => AppColors.statusActive,
      ProjectStatus.onHold => AppColors.statusOnHold,
      ProjectStatus.completed => AppColors.statusCompleted,
    };
  }

  static ProjectStatus statusFromValue(String status) {
    return switch (status) {
      'on_hold' => ProjectStatus.onHold,
      'completed' => ProjectStatus.completed,
      _ => ProjectStatus.active,
    };
  }

  static String statusLabel(ProjectStatus status) {
    return switch (status) {
      ProjectStatus.active => 'Active',
      ProjectStatus.onHold => 'On Hold',
      ProjectStatus.completed => 'Completed',
    };
  }

  static String statusValue(ProjectStatus status) {
    return switch (status) {
      ProjectStatus.active => 'active',
      ProjectStatus.onHold => 'on_hold',
      ProjectStatus.completed => 'completed',
    };
  }

  static IconData statusIcon(ProjectStatus status) {
    return switch (status) {
      ProjectStatus.active => Icons.play_circle_outline_rounded,
      ProjectStatus.onHold => Icons.pause_circle_outline_rounded,
      ProjectStatus.completed => Icons.check_circle_outline_rounded,
    };
  }
}
