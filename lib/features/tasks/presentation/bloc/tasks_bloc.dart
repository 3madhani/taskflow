import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/usecases/create_task_usecase.dart';
import '../../domain/usecases/get_tasks_usecase.dart';
import '../../domain/usecases/update_task_status_usecase.dart';
import 'tasks_event.dart';
import 'tasks_state.dart';

@injectable
class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final GetTasksUseCase _getTasksUseCase;
  final UpdateTaskStatusUseCase _updateTaskStatusUseCase;
  final CreateTaskUseCase _createTaskUseCase;

  TasksBloc(
    this._getTasksUseCase,
    this._updateTaskStatusUseCase,
    this._createTaskUseCase,
  ) : super(const TasksInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<UpdateTaskStatus>(_onUpdateTaskStatus);
    on<AddTask>(_onAddTask);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TasksState> emit) async {
    emit(const TasksLoading());
    final result = await _getTasksUseCase(event.projectId);
    result.fold(
      (failure) => emit(TasksError(failure.message)),
      (tasks) => emit(TasksLoaded(tasks)),
    );
  }

  Future<void> _onUpdateTaskStatus(
    UpdateTaskStatus event,
    Emitter<TasksState> emit,
  ) async {
    final currentTasks = _currentTasks();
    if (currentTasks == null) return;

    // Optimistic update
    final optimisticTasks = currentTasks.map((t) {
      if (t.id == event.taskId) return t.copyWith(status: event.newStatus);
      return t;
    }).toList();
    emit(TaskUpdating(tasks: optimisticTasks, updatingTaskId: event.taskId));

    // API call
    final result = await _updateTaskStatusUseCase(
      taskId: event.taskId,
      newStatus: event.newStatus,
    );

    result.fold(
      (failure) {
        // Revert on failure
        emit(TasksError(failure.message));
      },
      (updatedTask) {
        final updatedTasks = optimisticTasks.map((t) {
          if (t.id == updatedTask.id) return updatedTask;
          return t;
        }).toList();
        emit(TasksLoaded(updatedTasks));
      },
    );
  }

  Future<void> _onAddTask(AddTask event, Emitter<TasksState> emit) async {
    final currentTasks = _currentTasks() ?? [];

    final result = await _createTaskUseCase(
      title: event.title,
      projectId: event.projectId,
      priority: event.priority,
    );

    result.fold(
      (failure) => emit(TasksError(failure.message)),
      (newTask) {
        final updatedTasks = [...currentTasks, newTask];
        emit(TaskAdded(updatedTasks));
      },
    );
  }

  /// Helper to extract current tasks list from state
  List<TaskEntity>? _currentTasks() {
    final s = state;
    return switch (s) {
      TasksLoaded(:final tasks) => tasks,
      TaskUpdating(:final tasks) => tasks,
      TaskAdded(:final tasks) => tasks,
      _ => null,
    };
  }

  /// Cycle task status: pending → in_progress → done → pending
  static TaskStatus cycleStatus(TaskStatus current) {
    return switch (current) {
      TaskStatus.pending => TaskStatus.inProgress,
      TaskStatus.inProgress => TaskStatus.done,
      TaskStatus.done => TaskStatus.pending,
    };
  }
}
