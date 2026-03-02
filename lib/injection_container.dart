import 'package:get_it/get_it.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:virtual_valve_mqtt_controller/core/constants/mqtt_constants.dart';
import 'package:virtual_valve_mqtt_controller/features/valve_control/data/datasource/valve_mqtt_datasource.dart';
import 'package:virtual_valve_mqtt_controller/features/valve_control/data/repositories/valve_repository_impl.dart';
import 'package:virtual_valve_mqtt_controller/features/valve_control/domain/repositories/valve_repository.dart';
import 'package:virtual_valve_mqtt_controller/features/valve_control/domain/usecases/stream_valve_status_usecase.dart';
import 'package:virtual_valve_mqtt_controller/features/valve_control/domain/usecases/toggle_valve_usecase.dart';
import 'package:virtual_valve_mqtt_controller/features/valve_control/presentation/bloc/valve_bloc.dart';
import 'core/config/env_config.dart';

late final EnvConfig env;

final sl = GetIt.instance;

Future<void> init(EnvConfig config) async {
  env = config;

  sl.registerFactory(() => ValveBloc(toggleValve: sl(), streamStatus: sl()));

  sl.registerLazySingleton(() => ToggleValveUseCase(sl()));
  sl.registerLazySingleton(() => StreamValveStatusUseCase(sl()));

  sl.registerLazySingleton<ValveRepository>(() => ValveRepositoryImpl(sl()));

  sl.registerLazySingleton<ValveMqttDataSource>(
    () => ValveMqttDataSourceImpl(sl()),
  );

  final client = MqttServerClient(
    MqttConstants.broker,
    MqttConstants.clientIdentifier,
  );

  client.autoReconnect = true;
  client.resubscribeOnAutoReconnect = true;
  client.onAutoReconnect = () =>
      print('DEBUG: MQTT está tentando reconectar...');
  client.onConnected = () {
    print('DEBUG: MQTT Conectado! Inscrevendo no status...');
    client.subscribe(MqttConstants.topicStatus, MqttQos.atLeastOnce);
  };
  client.port = MqttConstants.port;
  client.logging(on: false);
  client.keepAlivePeriod = 20;

  sl.registerLazySingleton(() => client);
}
