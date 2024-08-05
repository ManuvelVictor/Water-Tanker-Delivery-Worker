import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_tanker_worker/screens/track_screen.dart';
import '../blocs/order_bloc.dart';
import '../states/order_state.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, ordersState) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              "Assigned Orders",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Total Tanks Delivered: ${ordersState.totalTanks}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Total Amount: ₹${ordersState.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: ordersState.assignedOrders.length,
                    itemBuilder: (context, index) {
                      final order = ordersState.assignedOrders[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(order.userName, style: const TextStyle(color: Colors.black),),
                          subtitle: Text(
                              '${order.numberOfTanks} tanks, ${order.location}'),
                          trailing: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TrackOrderScreen(
                                    orderId: order.id,
                                    latitude: order.latitude,
                                    longitude: order.longitude,
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'Track Location',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
