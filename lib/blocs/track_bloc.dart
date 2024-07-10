import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../events/track_event.dart';
import '../states/track_state.dart';

class TrackOrderBloc extends Bloc<TrackOrderEvent, TrackOrderState> {
  TrackOrderBloc()
      : super(const TrackOrderState(orderLocation: null, isTracking: false)) {
    on<RefreshLocationEvent>(_onRefreshLocation);
  }

  Future<void> _onRefreshLocation(
      RefreshLocationEvent event, Emitter<TrackOrderState> emit) async {
    try {
      emit(state.copyWith(isTracking: true));
      final orderRef =
          FirebaseFirestore.instance.collection('orders').doc(event.orderId);
      final orderSnapshot = await orderRef.get();
      final data = orderSnapshot.data();
      final location = data?['location'];
      emit(state.copyWith(
        orderLocation: location,
        isTracking: false,
      ));
    } catch (e) {
      emit(state.copyWith(isTracking: false));
      print('Error refreshing location: $e');
    }
  }
}
