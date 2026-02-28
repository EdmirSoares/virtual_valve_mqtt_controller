import 'package:virtual_valve_mqtt_controller/injection_container.dart';

class MqttConstants {
  static String get broker => env.mqttBroker;
  static int get port => env.mqttPort;
  static String get clientIdentifier => env.mqttClientId;
  static String get topicCommand => env.mqttTopicCommand;
  static String get topicStatus => env.mqttTopicStatus;
}
