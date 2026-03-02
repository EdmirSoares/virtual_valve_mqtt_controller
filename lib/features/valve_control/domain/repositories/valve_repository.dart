import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/valve_entity.dart';

abstract class ValveRepository {
  Future<Either<Failure, void>> toggleValve(String id, bool open);

  Stream<Either<Failure, ValveEntity>> watchValveStatus(String id);
}
