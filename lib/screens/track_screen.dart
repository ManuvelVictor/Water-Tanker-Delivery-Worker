import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../blocs/track_bloc.dart';
import '../events/track_event.dart';
import '../states/track_state.dart';

class TrackOrderScreen extends StatefulWidget {
  final String orderId;
  final double latitude;
  final double longitude;

  const TrackOrderScreen({
    super.key,
    required this.orderId,
    required this.latitude,
    required this.longitude,
  });

  @override
  TrackOrderScreenState createState() => TrackOrderScreenState();
}

class TrackOrderScreenState extends State<TrackOrderScreen> {
  late GoogleMapController _controller;
  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};
  late LatLng _destination;
  BitmapDescriptor? personIcon;

  @override
  void initState() {
    super.initState();
    _destination = const LatLng(11.081206902432173, 76.94137929896259);
    BlocProvider.of<TrackOrderBloc>(context)
        .add(StartTrackingEvent(widget.orderId));
    _fetchRoute();
    _loadCustomMarker();
    _addDestinationMarker();
  }

  void _addDestinationMarker() {
    _markers.add(
      Marker(
        markerId: const MarkerId('destination'),
        position: _destination,
        infoWindow: const InfoWindow(title: 'Destination'),
      ),
    );
  }



  Future<void> _loadCustomMarker() async {
    personIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(48, 48)), 'assets/truck_icon.png');
  }

  @override
  void dispose() {
    BlocProvider.of<TrackOrderBloc>(context).add(StopTrackingEvent());
    super.dispose();
  }

  Future<void> _fetchRoute() async {
    final currentLocation = await Geolocator.getCurrentPosition();
    final origin = '${currentLocation.latitude},${currentLocation.longitude}';
    const destination = '${11.081206902432173},${76.94137929896259}';
    const apiKey = 'AIzaSyD0kACOietBw9It5g_iGNE2vrJrRnv-cmY';
    final url = 'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final points = data['routes'][0]['overview_polyline']['points'];
      final polylinePoints = _decodePolyline(points);
      setState(() {
        _polylines.add(Polyline(
          polylineId: PolylineId('route'),
          points: polylinePoints,
          color: Colors.blue,
          width: 5,
        ));
      });
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;
    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;
      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;
      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return polyline;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Order'),
        centerTitle: true,
      ),
      body: BlocBuilder<TrackOrderBloc, TrackOrderState>(
        builder: (context, state) {
          if (state.currentPosition != null) {
            _markers.add(
              Marker(
                markerId: const MarkerId('worker'),
                position: state.currentPosition!,
                icon: personIcon ?? BitmapDescriptor.defaultMarker,
                infoWindow: const InfoWindow(title: 'Your Location'),
              ),
            );
          }
          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _destination,
              zoom: 14,
            ),
            markers: _markers,
            polylines: _polylines,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
          );
        },
      ),
    );
  }
}