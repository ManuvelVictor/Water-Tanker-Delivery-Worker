import 'package:equatable/equatable.dart';

class TrackOrderState extends Equatable {
  final String? orderLocation;
  final bool isTracking;

  const TrackOrderState({
    required this.orderLocation,
    required this.isTracking,
  });

  TrackOrderState copyWith({
    String? orderLocation,
    bool? isTracking,
  }) {
    return TrackOrderState(
      orderLocation: orderLocation ?? this.orderLocation,
      isTracking: isTracking ?? this.isTracking,
    );
  }

  @override
  List<Object?> get props => [orderLocation, isTracking];
}
