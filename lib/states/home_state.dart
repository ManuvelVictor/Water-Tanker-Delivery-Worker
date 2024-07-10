import 'package:equatable/equatable.dart';
import '../model/order.dart';

class HomeState extends Equatable {
  final int selectedTanks;
  final String currentLocationName;
  final double latitude;
  final double longitude;
  final List<Order> orders;
  final bool isFetchingOrders;
  final Order? assignedOrder;
  final String? orderFailure;
  final bool isPlacingOrder;

  const HomeState({
    required this.selectedTanks,
    required this.currentLocationName,
    required this.orders,
    required this.isFetchingOrders,
    this.assignedOrder,
    this.orderFailure,
    this.latitude = 0.0,
    this.longitude = 0.0,
    required this.isPlacingOrder,
  });

  HomeState copyWith({
    int? selectedTanks,
    String? currentLocationName,
    double? latitude,
    double? longitude,
    List<Order>? orders,
    bool? isFetchingOrders,
    Order? assignedOrder,
    String? orderFailure,
    bool? isPlacingOrder,
  }) {
    return HomeState(
      selectedTanks: selectedTanks ?? this.selectedTanks,
      currentLocationName: currentLocationName ?? this.currentLocationName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      orders: orders ?? this.orders,
      isFetchingOrders: isFetchingOrders ?? this.isFetchingOrders,
      assignedOrder: assignedOrder ?? this.assignedOrder,
      orderFailure: orderFailure ?? this.orderFailure,
      isPlacingOrder: isPlacingOrder ?? this.isPlacingOrder,
    );
  }

  @override
  List<Object?> get props => [
        selectedTanks,
        currentLocationName,
        latitude,
        longitude,
        orders,
        isFetchingOrders,
        assignedOrder,
        orderFailure,
        isPlacingOrder,
      ];
}
