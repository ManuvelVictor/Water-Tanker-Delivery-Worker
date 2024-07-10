abstract class HomeEvent {}

class UpdateLocationEvent extends HomeEvent {}

class PlaceOrderEvent extends HomeEvent {}

class AssignOrderEvent extends HomeEvent {
  final String orderId;

  AssignOrderEvent(this.orderId);
}