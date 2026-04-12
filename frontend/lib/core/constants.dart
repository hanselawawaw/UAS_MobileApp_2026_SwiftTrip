import 'package:flutter/material.dart';

class Constants {
  Constants._();

  // App Information
  static const String appName = 'SwiftTrip';

  // Colors — Primary Palette
  static const Color primaryBlue = Color(0xFF0098FF);
  static const Color primaryBlueAlt = Color(0xFF2B99E3);
  static const Color primaryDark = Color(0xFF15233E);
  static const Color primaryBlack = Color(0xFF000000);

  // Colors — Secondary Palette
  static const Color secondaryWhite = Color(0xFFFFFFFF);
  static const Color secondaryGrey = Color(0xFF999999);

  // Colors — Popup/Status
  static const Color popupSuccess = Color(0xFF02C518);
  static const Color popupWarning = Color(0xFFFFCC00);
  static const Color popupError = Color(0xFFE25142);

  // Colors — Warning
  static const Color warningColor = Color(0xFFF3CFCE);

  // Update this ONE line whenever you change Wi-Fi networks (use 127.0.0.1 for Web, 10.0.2.2 for Android Emulator, or your IPv4 for real devices)
  static const String machineIp = 'localhost';

  static const String baseUrl = 'http://$machineIp:8000/api/auth/';
  static const String travelUrl = 'http://$machineIp:8000/api/travel/';
  static const String promotionsUrl = 'http://$machineIp:8000/api/promotions/';
  static const String bookingsUrl = 'http://$machineIp:8000/api/bookings/';
  static const String historyUrl = 'http://$machineIp:8000/api/bookings/history/';
  static const String supportUrl = 'http://$machineIp:8000/api/support/';
}
