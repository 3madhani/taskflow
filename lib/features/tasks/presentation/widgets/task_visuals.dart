import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/task_entity.dart';

class TaskVisuals {
  TaskVisuals._();

  static Color priorityColor(TaskPriority priority) {
    return switch (priority) {
      TaskPriority.low => AppColors.priorityLow,
      TaskPriority.medium => AppColors.priorityMedium,
      TaskPriority.high => AppColors.priorityHigh,
    };
  }

  static IconData priorityIcon(TaskPriority priority) {
    return switch (priority) {
      TaskPriority.low => Icons.arrow_downward_rounded,
      TaskPriority.medium => Icons.remove_rounded,
      TaskPriority.high => Icons.arrow_upward_rounded,
    };
  }

  static String priorityLabel(TaskPriority priority) {
    return switch (priority) {
      TaskPriority.low => 'Low',
      TaskPriority.medium => 'Medium',
      TaskPriority.high => 'High',
    };
  }

  static Color statusColor(TaskStatus status) {
    return switch (status) {
      TaskStatus.pending => AppColors.statusPending,
      TaskStatus.inProgress => AppColors.statusInProgress,
      TaskStatus.done => AppColors.statusDone,
    };
  }

  static IconData statusIcon(TaskStatus status) {
    return switch (status) {
      TaskStatus.pending => Icons.radio_button_unchecked_rounded,
      TaskStatus.inProgress => Icons.timelapse_rounded,
      TaskStatus.done => Icons.check_circle_rounded,
    };
  }

  static String statusLabel(TaskStatus status) {
    return switch (status) {
      TaskStatus.pending => 'Pending',
      TaskStatus.inProgress => 'In Progress',
      TaskStatus.done => 'Done',
    };
  }
}
