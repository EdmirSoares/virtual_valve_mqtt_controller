import 'dart:async';
import 'package:fpdart/fpdart.dart';
import 'package:virtual_valve_mqtt_controller/features/valve_control/data/datasource/valve_mqtt_datasource.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/valve_entity.dart';
import '../../domain/repositories/valve_repository.dart';

class ValveRepositoryImpl implements ValveRepository {
  final ValveMqttDataSource dataSource;

  ValveRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, void>> toggleValve(String id, bool open) async {
    try {
      final payload = open ? 'OPEN' : 'CLOSED';
      await dataSource.publishCommand(payload);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, ValveEntity>> watchValveStatus(String id) {
    return dataSource.statusStream
        .map<Either<Failure, ValveEntity>>((model) => Right(model))
        .handleError((error) => Left(ServerFailure(error.toString())));
  }
}
