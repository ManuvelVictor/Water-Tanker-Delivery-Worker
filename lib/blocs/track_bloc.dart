import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../events/track_event.dart';
import '../states/track_state.dart';

class TrackOrderBloc extends Bloc<TrackOrderEvent, TrackOrderState> {
  StreamSubscription<Position>? _positionStreamSubscription;
  final firestore.FirebaseFirestore _firestore =
      firestore.FirebaseFirestore.instance;

  TrackOrderBloc() : super(const TrackOrderState()) {
    on<StartTrackingEvent>(_onStartTracking);
    on<StopTrackingEvent>(_onStopTracking);
  }

  Future<void> _onStartTracking(
      StartTrackingEvent event, Emitter<TrackOrderState> emit) async {
    _positionStreamSubscription = Geolocator.getPositionStream().listen((Position position) async {
      await _updateWorkerLocationInFirestore(event.orderId, position.latitude, position.longitude);
    });
  }

  Future<void> _updateWorkerLocationInFirestore(String orderId, double latitude, double longitude) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'workerLocation': {
          'latitude': latitude,
          'longitude': longitude,
        },
      });
      print("Worker location updated in Firestore successfully");
    } catch (e) {
      print("Failed to update worker location in Firestore: $e");
    }
  }

  void _onStopTracking(StopTrackingEvent event, Emitter<TrackOrderState> emit) {
    _positionStreamSubscription?.cancel();
  }

  @override
  Future<void> close() {
    _positionStreamSubscription?.cancel();
    return super.close();
  }
}