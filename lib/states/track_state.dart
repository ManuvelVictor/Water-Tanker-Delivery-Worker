import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackOrderState extends Equatable {
  final LatLng? currentPosition;

  const TrackOrderState({this.currentPosition});

  TrackOrderState copyWith({LatLng? currentPosition}) {
    return TrackOrderState(
      currentPosition: currentPosition ?? this.currentPosition,
    );
  }

  @override
  List<Object?> get props => [currentPosition];
}
