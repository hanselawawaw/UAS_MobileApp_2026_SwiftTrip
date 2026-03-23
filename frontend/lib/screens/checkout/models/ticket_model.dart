class TicketModel {
  final String classType;
  final String from;
  final String to;
  final String date;
  final String departureTime;
  final String arrivalTime;
  final String trainNumber;
  final String carriage;
  final String seatNumber;

  const TicketModel({
    required this.classType,
    required this.from,
    required this.to,
    required this.date,
    required this.departureTime,
    required this.arrivalTime,
    required this.trainNumber,
    required this.carriage,
    required this.seatNumber,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      classType: json['class_type'] as String,
      from: json['from'] as String,
      to: json['to'] as String,
      date: json['date'] as String,
      departureTime: json['departure_time'] as String,
      arrivalTime: json['arrival_time'] as String,
      trainNumber: json['train_number'] as String,
      carriage: json['carriage'] as String,
      seatNumber: json['seat_number'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'class_type': classType,
      'from': from,
      'to': to,
      'date': date,
      'departure_time': departureTime,
      'arrival_time': arrivalTime,
      'train_number': trainNumber,
      'carriage': carriage,
      'seat_number': seatNumber,
    };
  }
}
