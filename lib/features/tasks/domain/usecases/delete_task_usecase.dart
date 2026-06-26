import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/tasks_repository.dart';

@injectable
class DeleteTaskUseCase {
  final TasksRepository _repository;

  const DeleteTaskUseCase(this._repository);

  Future<Either<Failure, void>> call(String taskId) {
    return _repository.deleteTask(taskId);
  }
}
