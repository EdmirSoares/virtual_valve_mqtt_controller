import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/valve_entity.dart';
import '../repositories/valve_repository.dart';

class StreamValveStatusUseCase {
  final ValveRepository repository;

  StreamValveStatusUseCase(this.repository);

  Stream<Either<Failure, ValveEntity>> call(String id) {
    return repository.watchValveStatus(id);
  }
}
