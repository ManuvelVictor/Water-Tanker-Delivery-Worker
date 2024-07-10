import 'package:equatable/equatable.dart';
import '../model/order.dart';

class OrdersState extends Equatable {
  final List<Order> assignedOrders;
  final int totalTanks;
  final double totalAmount;

  const OrdersState({
    required this.assignedOrders,
    required this.totalTanks,
    required this.totalAmount,
  });

  OrdersState copyWith({
    List<Order>? assignedOrders,
    int? totalTanks,
    double? totalAmount,
  }) {
    return OrdersState(
      assignedOrders: assignedOrders ?? this.assignedOrders,
      totalTanks: totalTanks ?? this.totalTanks,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }

  @override
  List<Object?> get props => [assignedOrders, totalTanks, totalAmount];
}
