import 'package:equatable/equatable.dart';
import '../../domain/entities/valve_entity.dart';

abstract class ValveState extends Equatable {
  const ValveState();
  @override
  List<Object?> get props => [];
}

class ValveInitial extends ValveState {}

class ValveLoading extends ValveState {}

class ValveLoaded extends ValveState {
  final ValveEntity valve;
  final bool isPending;

  const ValveLoaded({required this.valve, this.isPending = false});

  ValveLoaded copyWith({ValveEntity? valve, bool? isPending}) {
    return ValveLoaded(
      valve: valve ?? this.valve,
      isPending: isPending ?? this.isPending,
    );
  }

  @override
  List<Object?> get props => [valve, isPending];
}

class ValveError extends ValveState {
  final String message;
  const ValveError(this.message);
}
