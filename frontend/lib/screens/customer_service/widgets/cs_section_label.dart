import 'package:flutter/material.dart';

class CsSectionLabel extends StatelessWidget {
  final String text;

  const CsSectionLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        fontSize: 16,
        height: 2.19,
        color: Color(0xFFA0A0A0),
      ),
    );
  }
}
