import 'package:flutter/foundation.dart';

@immutable
class CartTicket {
  final String
  type; // 'Car Ticket', 'Bus Ticket', 'Train Ticket', 'Plane Ticket', 'Accommodation Ticket'
  final String bookingId;
  final String classLabel;
  final int priceRp;

  // General operator for all transport
  final String? operator;

  // Shared transport fields
  final String? from;
  final String? to;
  final String? date;
  final String? departure;
  final String? arrive;

  // Train-specific
  final String? carriage;
  final String? seat;
  final String? trainNumber;

  // Flight-specific
  final String? flightNumber;
  final String? terminal;
  final String? flightClass;

  // Bus-specific
  final String? busClass;
  final String? busNumber;

  // Car rental-specific
  final String? carPlate;
  final String? driverName;

  // Flight-specific route path
  final List<String>? flightRoute;

  // Accommodation fields
  final String? imageUrl;
  final String? stayDate;
  final String? stayDuration;
  final String? bedType;
  final String? location;

  const CartTicket({
    required this.type,
    required this.bookingId,
    required this.classLabel,
    required this.priceRp,
    this.from,
    this.to,
    this.date,
    this.departure,
    this.arrive,
    this.operator,
    this.carriage,
    this.seat,
    this.trainNumber,
    this.flightNumber,
    this.terminal,
    this.flightClass,
    this.busClass,
    this.busNumber,
    this.carPlate,
    this.driverName,
    this.imageUrl,
    this.stayDate,
    this.stayDuration,
    this.bedType,
    this.location,
    this.flightRoute,
  });

  factory CartTicket.accommodation({
    required String locationName,
    required int price,
    required String imageUrl,
    required String stayDate,
    required int stayDuration,
    String? bookingId,
    String? classLabel,
  }) {
    return CartTicket(
      type: 'Accommodation Ticket',
      bookingId: bookingId ?? '',
      classLabel: classLabel ?? 'Standard',
      priceRp: price,
      imageUrl: imageUrl,
      stayDate: stayDate,
      stayDuration: stayDuration.toString(),
      location: locationName,
    );
  }

  factory CartTicket.fromJson(Map<String, dynamic> json) {
    return CartTicket(
      type: json['type'] as String,
      bookingId: json['booking_id'] as String,
      classLabel: json['class_label'] as String,
      priceRp: json['price_rp'] as int,
      from: json['from'] as String?,
      to: json['to'] as String?,
      date: json['date'] as String?,
      departure: json['departure'] as String?,
      arrive: json['arrive'] as String?,
      operator: json['operator'] as String?,
      carriage: json['carriage'] as String?,
      seat: json['seat'] as String?,
      trainNumber: json['train_number'] as String?,
      flightNumber: json['flight_number'] as String?,
      terminal: json['terminal'] as String?,
      flightClass: json['flight_class'] as String?,
      busClass: json['bus_class'] as String?,
      busNumber: json['bus_number'] as String?,
      carPlate: json['car_plate'] as String?,
      driverName: json['driver_name'] as String?,
      imageUrl: json['image_url'] as String?,
      stayDate: json['stay_date'] as String?,
      stayDuration: json['stay_duration'] as String?,
      bedType: json['bed_type'] as String?,
      location: json['location'] as String?,
      flightRoute: (json['flight_route'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'booking_id': bookingId,
      'class_label': classLabel,
      'price_rp': priceRp,
      'from': from,
      'to': to,
      'date': date,
      'departure': departure,
      'arrive': arrive,
      'operator': operator,
      'carriage': carriage,
      'seat': seat,
      'train_number': trainNumber,
      'flight_number': flightNumber,
      'terminal': terminal,
      'flight_class': flightClass,
      'bus_class': busClass,
      'bus_number': busNumber,
      'car_plate': carPlate,
      'driver_name': driverName,
      'image_url': imageUrl,
      'stay_date': stayDate,
      'stay_duration': stayDuration,
      'bed_type': bedType,
      'location': location,
      'flight_route': flightRoute,
      'booking_type': _mapTypeToBookingType(type),
    };
  }

  String _mapTypeToBookingType(String type) {
    switch (type) {
      case 'Plane Ticket':
        return 'PLANE_TICKET';
      case 'Train Ticket':
        return 'TRAIN_TICKET';
      case 'Bus Ticket':
        return 'BUS_TICKET';
      case 'Car Ticket':
        return 'CAR_TICKET';
      case 'Accommodation Ticket':
        return 'ACCOMMODATION';
      default:
        return 'TRAIN_TICKET';
    }
  }

  CartTicket copyWith({
    String? type,
    String? bookingId,
    String? classLabel,
    int? priceRp,
    String? from,
    String? to,
    String? date,
    String? departure,
    String? arrive,
    String? operator,
    String? carriage,
    String? seat,
    String? trainNumber,
    String? flightNumber,
    String? terminal,
    String? flightClass,
    String? busClass,
    String? busNumber,
    String? carPlate,
    String? driverName,
    String? imageUrl,
    String? stayDate,
    String? stayDuration,
    String? bedType,
    String? location,
    List<String>? flightRoute,
  }) {
    return CartTicket(
      type: type ?? this.type,
      bookingId: bookingId ?? this.bookingId,
      classLabel: classLabel ?? this.classLabel,
      priceRp: priceRp ?? this.priceRp,
      from: from ?? this.from,
      to: to ?? this.to,
      date: date ?? this.date,
      departure: departure ?? this.departure,
      arrive: arrive ?? this.arrive,
      operator: operator ?? this.operator,
      carriage: carriage ?? this.carriage,
      seat: seat ?? this.seat,
      trainNumber: trainNumber ?? this.trainNumber,
      flightNumber: flightNumber ?? this.flightNumber,
      terminal: terminal ?? this.terminal,
      flightClass: flightClass ?? this.flightClass,
      busClass: busClass ?? this.busClass,
      busNumber: busNumber ?? this.busNumber,
      carPlate: carPlate ?? this.carPlate,
      driverName: driverName ?? this.driverName,
      imageUrl: imageUrl ?? this.imageUrl,
      stayDate: stayDate ?? this.stayDate,
      stayDuration: stayDuration ?? this.stayDuration,
      bedType: bedType ?? this.bedType,
      location: location ?? this.location,
      flightRoute: flightRoute ?? this.flightRoute,
    );
  }
}
