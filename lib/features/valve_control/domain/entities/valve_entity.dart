import 'package:equatable/equatable.dart';

enum ValveStatus { open, closed, pending }

class ValveEntity extends Equatable {
  final String id;
  final ValveStatus status;
  final DateTime lastUpdated;

  const ValveEntity({
    required this.id,
    required this.status,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [id, status, lastUpdated];
}
