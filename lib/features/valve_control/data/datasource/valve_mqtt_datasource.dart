import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../../../../core/constants/mqtt_constants.dart';
import '../models/valve_model.dart';

abstract class ValveMqttDataSource {
  Future<void> publishCommand(String payload);
  Stream<ValveModel> get statusStream;
}

class ValveMqttDataSourceImpl implements ValveMqttDataSource {
  final MqttServerClient client;

  ValveMqttDataSourceImpl(this.client);

  @override
  Future<void> publishCommand(String payload) async {
    final builder = MqttClientPayloadBuilder();
    builder.addString(payload);

    if (client.connectionStatus!.state != MqttConnectionState.connected) {
      await client.connect();
    }

    client.publishMessage(
      MqttConstants.topicCommand,
      MqttQos.atLeastOnce,
      builder.payload!,
    );
  }

  @override
  Stream<ValveModel> get statusStream {
    return Stream.fromFuture(_ensureConnected()).asyncExpand((_) {
      if (client.updates == null) {
        return const Stream.empty();
      }
      return client.updates!.map((List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(
          recMess.payload.message,
        );
        return ValveModel.fromMqtt(payload, 'valve_001');
      });
    });
  }

  Future<void> _ensureConnected() async {
    if (client.connectionStatus?.state != MqttConnectionState.connected) {
      try {
        await client.connect();
        client.subscribe(MqttConstants.topicStatus, MqttQos.atLeastOnce);
      } catch (e) {
        print('DEBUG: Connection failed: $e');
      }
    }
  }
}
