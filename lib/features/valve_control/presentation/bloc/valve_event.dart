// lib/features/valve_control/presentation/bloc/valve_event.dart
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/valve_entity.dart';

abstract class ValveEvent extends Equatable {
  const ValveEvent();
  @override
  List<Object?> get props => [];
}

class ConnectToValve extends ValveEvent {}

class ToggleValveCommand extends ValveEvent {
  final bool open;
  const ToggleValveCommand(this.open);
}

class InternalUpdateReceived extends ValveEvent {
  final Either<Failure, ValveEntity> result;
  const InternalUpdateReceived(this.result);

  @override
  List<Object?> get props => [result];
}
