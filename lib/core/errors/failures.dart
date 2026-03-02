import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = "Erro no MQTT Broker"]);
}

class ConnectionFailure extends Failure {
  const ConnectionFailure([
    super.message = "Falha ao tentar se conectar ao MQTT Broker",
  ]);
}
