abstract class TrackOrderEvent {}

class RefreshLocationEvent extends TrackOrderEvent {
  final String orderId;

  RefreshLocationEvent(this.orderId);
}
