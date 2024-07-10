import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/track_bloc.dart';
import '../events/track_event.dart';
import '../states/track_state.dart';

class TrackOrderScreen extends StatelessWidget {
  final String orderId;

  const TrackOrderScreen({required this.orderId, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackOrderBloc, TrackOrderState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Track Order'),
          ),
          body: Center(
            child: state.isTracking
                ? const CircularProgressIndicator()
                : state.orderLocation == null
                    ? const Text('No location data available')
                    : // Show map with order location
                    Text('Order Location: ${state.orderLocation}'),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.read<TrackOrderBloc>().add(RefreshLocationEvent(orderId));
            },
            child: const Icon(Icons.refresh),
          ),
        );
      },
    );
  }
}
