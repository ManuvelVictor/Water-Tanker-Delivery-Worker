import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String id;
  final double latitude;
  final double longitude;
  final String location;
  final int numberOfTanks;
  final Timestamp timestamp; // Firestore timestamp
  final String userName;

  Order({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.location,
    required this.numberOfTanks,
    required this.timestamp,
    required this.userName,
  });

  factory Order.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Order(
      id: doc.id,
      latitude: data['latitude']?.toDouble() ?? 0.0,
      longitude: data['longitude']?.toDouble() ?? 0.0,
      location: data['location'] ?? '',
      numberOfTanks: data['numberOfTanks'] ?? 0,
      timestamp: data['timestamp'] ?? Timestamp.now(),
      userName: data['userName'] ?? '',
    );
  }
}