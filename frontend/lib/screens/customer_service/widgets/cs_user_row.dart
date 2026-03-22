import 'package:flutter/material.dart';

class CsUserRow extends StatelessWidget {
  final String username;

  const CsUserRow({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 33.52,
          height: 33.52,
          decoration: const ShapeDecoration(
            color: Colors.white,
            shape: OvalBorder(),
            shadows: [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 20,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.person_outline,
            size: 16,
            color: Colors.black54,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          username,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            fontSize: 12,
            height: 1.67,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
