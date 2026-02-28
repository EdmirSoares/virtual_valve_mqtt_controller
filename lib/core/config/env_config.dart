import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  final String mqttBroker;
  final int mqttPort;
  final String mqttClientId;
  final String mqttTopicCommand;
  final String mqttTopicStatus;

  EnvConfig({
    required this.mqttBroker,
    required this.mqttPort,
    required this.mqttClientId,
    required this.mqttTopicCommand,
    required this.mqttTopicStatus,
  });

  factory EnvConfig.fromDotEnv() {
    String require(String key) {
      final value = dotenv.env[key];
      if (value == null || value.isEmpty) {
        throw Exception('Variável obrigatória não encontrada no .env');
      }
      return value;
    }

    return EnvConfig(
      mqttBroker: require('MQTT_BROKER'),
      mqttPort: int.parse(require('MQTT_PORT')),
      mqttClientId: require('MQTT_CLIENT_ID'),
      mqttTopicCommand: require('MQTT_TOPIC_COMMAND'),
      mqttTopicStatus: require('MQTT_TOPIC_STATUS'),
    );
  }
}
