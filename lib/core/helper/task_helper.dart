import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../enums/app_enums.dart';

class TaskHelper {
  TaskHelper._();

  static Color priorityColor(TaskPriority priority) {
    return switch (priority) {
      TaskPriority.low => AppColors.priorityLow,
      TaskPriority.medium => AppColors.priorityMedium,
      TaskPriority.high => AppColors.priorityHigh,
    };
  }

  static Color priorityColorFromValue(String priority) {
    return priorityColor(priorityFromValue(priority));
  }

  static TaskPriority priorityFromValue(String priority) {
    return switch (priority) {
      'low' => TaskPriority.low,
      'high' => TaskPriority.high,
      _ => TaskPriority.medium,
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

  static String priorityLabelFromValue(String priority) {
    return priorityLabel(priorityFromValue(priority));
  }

  static String priorityValue(TaskPriority priority) {
    return priority.name;
  }

  static double completionProgress({
    required int completed,
    required int total,
  }) {
    return total == 0 ? 0.0 : completed / total;
  }

  static Color statusColor(TaskStatus status) {
    return switch (status) {
      TaskStatus.pending => AppColors.statusPending,
      TaskStatus.inProgress => AppColors.statusInProgress,
      TaskStatus.done => AppColors.statusDone,
    };
  }

  static Color statusColorFromValue(String status) {
    return statusColor(statusFromValue(status));
  }

  static TaskStatus statusFromValue(String status) {
    return switch (status) {
      'done' => TaskStatus.done,
      'in_progress' => TaskStatus.inProgress,
      _ => TaskStatus.pending,
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

  static String statusLabelFromValue(String status) {
    return statusLabel(statusFromValue(status));
  }

  static int statusCount(Iterable<TaskStatus> statuses, TaskStatus status) {
    return statuses.where((taskStatus) => taskStatus == status).length;
  }

  static String statusValue(TaskStatus status) {
    return switch (status) {
      TaskStatus.inProgress => 'in_progress',
      TaskStatus.done => 'done',
      TaskStatus.pending => 'pending',
    };
  }
}
