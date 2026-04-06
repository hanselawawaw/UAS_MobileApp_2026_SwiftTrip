class TicketModel {
  final String type;
  final String classType;
  final String from;
  final String to;
  final String date;
  final String departureTime;
  final String arrivalTime;
  
  // Specific fields
  final String? trainNumber;
  final String? carriage;
  final String? seatNumber;
  final String? flightNumber;
  final String? airline;
  final String? carPlate;
  final String? busNumber;
  final String? operator;

  const TicketModel({
    required this.type,
    required this.classType,
    required this.from,
    required this.to,
    required this.date,
    required this.departureTime,
    required this.arrivalTime,
    this.trainNumber,
    this.carriage,
    this.seatNumber,
    this.flightNumber,
    this.airline,
    this.carPlate,
    this.busNumber,
    this.operator,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      type: json['type'] as String? ?? 'Train',
      classType: json['class_type'] as String,
      from: json['from'] as String,
      to: json['to'] as String,
      date: json['date'] as String,
      departureTime: json['departure_time'] as String,
      arrivalTime: json['arrival_time'] as String,
      trainNumber: json['train_number'] as String?,
      carriage: json['carriage'] as String?,
      seatNumber: json['seat_number'] as String?,
      flightNumber: json['flight_number'] as String?,
      airline: json['airline'] as String?,
      carPlate: json['car_plate'] as String?,
      busNumber: json['bus_number'] as String?,
      operator: json['operator'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'class_type': classType,
      'from': from,
      'to': to,
      'date': date,
      'departure_time': departureTime,
      'arrival_time': arrivalTime,
      'train_number': trainNumber,
      'carriage': carriage,
      'seat_number': seatNumber,
      'flight_number': flightNumber,
      'airline': airline,
      'car_plate': carPlate,
      'bus_number': busNumber,
      'operator': operator,
    };
  }
}

