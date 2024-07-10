import 'package:flutter_bloc/flutter_bloc.dart';
import '../events/order_event.dart';
import '../states/order_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import '../model/order.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc()
      : super(const OrdersState(
      assignedOrders: [], totalTanks: 0, totalAmount: 0.0)) {
    on<FetchAssignedOrdersEvent>(_onFetchAssignedOrders);
  }

  Future<void> _onFetchAssignedOrders(
      FetchAssignedOrdersEvent event, Emitter<OrdersState> emit) async {
    try {
      final ordersQuery = firestore.FirebaseFirestore.instance
          .collection('orders');
      final ordersSnapshot = await ordersQuery.get();

      final assignedOrders = ordersSnapshot.docs
          .map((doc) => Order.fromDocument(doc))
          .toList();

      int totalTanks =
      assignedOrders.fold(0, (sum, order) => sum + order.numberOfTanks);
      double totalAmount = 0.0;

      emit(state.copyWith(
        assignedOrders: assignedOrders,
        totalTanks: totalTanks,
        totalAmount: totalAmount,
      ));
    } catch (e) {
      print('Error fetching assigned orders: $e');
    }
  }
}
