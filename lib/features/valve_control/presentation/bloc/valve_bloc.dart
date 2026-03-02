import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:virtual_valve_mqtt_controller/core/errors/failures.dart';
import '../../domain/usecases/stream_valve_status_usecase.dart';
import '../../domain/usecases/toggle_valve_usecase.dart';
import 'valve_event.dart';
import 'valve_state.dart';

class ValveBloc extends Bloc<ValveEvent, ValveState> {
  final ToggleValveUseCase toggleValve;
  final StreamValveStatusUseCase streamStatus;
  StreamSubscription? _statusSubscription;

  ValveBloc({required this.toggleValve, required this.streamStatus})
    : super(ValveInitial()) {
    on<ConnectToValve>(_onConnect);
    on<ToggleValveCommand>(_onToggle);
    on<InternalUpdateReceived>(_onUpdateReceived);
  }
  Future<void> _onConnect(
    ConnectToValve event,
    Emitter<ValveState> emit,
  ) async {
    emit(ValveLoading());

    try {
      _statusSubscription?.cancel();

      _statusSubscription = streamStatus('valve_001').listen(
        (result) {
          add(InternalUpdateReceived(result));
        },
        onError: (error) {
          add(InternalUpdateReceived(Left(ServerFailure(error.toString()))));
        },
      );
    } catch (e) {
      emit(ValveError("Connection Error: ${e.toString()}"));
    }
  }

  Future<void> _onToggle(
    ToggleValveCommand event,
    Emitter<ValveState> emit,
  ) async {
    final currentState = state;
    if (currentState is ValveLoaded) {
      emit(currentState.copyWith(isPending: true));

      final result = await toggleValve('valve_001', event.open);

      result.fold((failure) => emit(ValveError(failure.message)), (_) => null);
    }
  }

  void _onUpdateReceived(
    InternalUpdateReceived event,
    Emitter<ValveState> emit,
  ) {
    event.result.fold(
      (failure) => emit(ValveError(failure.message)),
      (valve) => emit(ValveLoaded(valve: valve, isPending: false)),
    );
  }

  @override
  Future<void> close() {
    _statusSubscription?.cancel();
    return super.close();
  }
}
