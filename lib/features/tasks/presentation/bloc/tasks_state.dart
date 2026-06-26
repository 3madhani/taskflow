import 'package:equatable/equatable.dart';
import '../../domain/entities/task_entity.dart';

sealed class TasksState extends Equatable {
  const TasksState();
}

class TasksInitial extends TasksState {
  const TasksInitial();

  @override
  List<Object?> get props => [];
}

class TasksLoading extends TasksState {
  const TasksLoading();

  @override
  List<Object?> get props => [];
}

class TasksLoaded extends TasksState {
  final List<TaskEntity> tasks;

  const TasksLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class TasksError extends TasksState {
  final String message;

  const TasksError(this.message);

  @override
  List<Object?> get props => [message];
}

class TaskUpdating extends TasksState {
  final List<TaskEntity> tasks;
  final String updatingTaskId;

  const TaskUpdating({required this.tasks, required this.updatingTaskId});

  @override
  List<Object?> get props => [tasks, updatingTaskId];
}

class TaskAdded extends TasksState {
  final List<TaskEntity> tasks;

  const TaskAdded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class TaskUpdated extends TasksState {
  final List<TaskEntity> tasks;

  const TaskUpdated(this.tasks);

  @override
  List<Object?> get props => [tasks];
}
