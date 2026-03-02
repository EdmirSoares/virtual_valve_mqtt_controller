import '../../domain/entities/valve_entity.dart';

class ValveModel extends ValveEntity {
  const ValveModel({
    required super.id,
    required super.status,
    required super.lastUpdated,
  });

  factory ValveModel.fromMqtt(String payload, String id) {
    return ValveModel(
      id: id,
      status: payload.toUpperCase() == 'OPEN'
          ? ValveStatus.open
          : ValveStatus.closed,
      lastUpdated: DateTime.now(),
    );
  }

  String toMqttPayload() => status == ValveStatus.open ? 'OPEN' : 'CLOSED';
}
