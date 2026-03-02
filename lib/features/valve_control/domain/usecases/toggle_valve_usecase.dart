import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/valve_repository.dart';

class ToggleValveUseCase {
  final ValveRepository repository;

  ToggleValveUseCase(this.repository);

  Future<Either<Failure, void>> call(String id, bool open) async {
    return await repository.toggleValve(id, open);
  }
}
