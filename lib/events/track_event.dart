import 'package:equatable/equatable.dart';

abstract class TrackOrderEvent extends Equatable {
  const TrackOrderEvent();

  @override
  List<Object> get props => [];
}

class StartTrackingEvent extends TrackOrderEvent {
  final String orderId;

  const StartTrackingEvent(this.orderId);

  @override
  List<Object> get props => [orderId];
}

class StopTrackingEvent extends TrackOrderEvent {}
