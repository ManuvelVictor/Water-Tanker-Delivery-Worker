import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../events/home_event.dart';
import '../states/home_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:water_tanker_worker/model/order.dart' as custom_order;

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState(
    selectedTanks: 1,
    currentLocationName: "Tap here to get current location",
    orders: [],
    isPlacingOrder: false, isFetchingOrders: false,
  )) {
    on<UpdateLocationEvent>(_onUpdateLocation);
    on<PlaceOrderEvent>(_onPlaceOrder);
    on<AssignOrderEvent>(_onAssignOrder);
  }

  Future<void> _onUpdateLocation(UpdateLocationEvent event, Emitter<HomeState> emit) async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placeMarks = await placemarkFromCoordinates(
        position.latitude, position.longitude,
      );
      if (placeMarks.isNotEmpty) {
        emit(state.copyWith(
          currentLocationName: "${placeMarks.first.locality}, ${placeMarks.first.country}",
          latitude: position.latitude,
          longitude: position.longitude,
        ));
        // Update location in Firebase
        await firestore.FirebaseFirestore.instance.collection('workers').doc('workerId').update({
          'location': {
            'latitude': position.latitude,
            'longitude': position.longitude,
          },
          'locationName': state.currentLocationName,
        });
      }
    } catch (e) {
      print('Error updating location: $e');
    }
  }

  Future<void> _onPlaceOrder(PlaceOrderEvent event, Emitter<HomeState> emit) async {
    // Place order logic
  }

  Future<void> _onAssignOrder(AssignOrderEvent event, Emitter<HomeState> emit) async {
    try {
      emit(state.copyWith(isFetchingOrders: true));
      final orderRef = firestore.FirebaseFirestore.instance.collection('orders').doc(event.orderId);
      final orderSnapshot = await orderRef.get();
      if (orderSnapshot.exists) {
        final order = custom_order.Order.fromDocument(orderSnapshot);
        await orderRef.update({'assignedTo': 'workerId'});
        emit(state.copyWith(
          assignedOrder: order,
          orders: [], // Clear available orders
          isFetchingOrders: false,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isFetchingOrders: false,
        orderFailure: e.toString(),
      ));
    }
  }
}
