import 'package:flutter/material.dart';

class AuthWidgets {
  static Widget inputField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    Widget? suffixIcon,
  }) {
    return Container(
      width: 347,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: ShapeDecoration(
        color: const Color(0xFFE8EDF2),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFD1DEE5)),
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 20,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              keyboardType: hint == 'Email'
                  ? TextInputType.emailAddress
                  : TextInputType.text,
              style: const TextStyle(
                color: Color(0xFF0C161C),
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  color: Color(0xFF4F7A93),
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
          ?suffixIcon,
        ],
      ),
    );
  }

  static Widget verificationField({
    required TextEditingController controller,
    required String hint,
    required VoidCallback onAskCode,
  }) {
    return Container(
      width: 347,
      height: 56,
      decoration: ShapeDecoration(
        color: const Color(0xFFE8EDF2),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFD1DEE5)),
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                color: Color(0xFF0C161C),
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  color: Color(0xFF4F7A93),
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(right: 90),
                isDense: true,
              ),
            ),
          ),
          GestureDetector(
            onTap: onAskCode,
            child: Container(
              width: 80,
              height: 40,
              margin: const EdgeInsets.only(right: 8),
              decoration: ShapeDecoration(
                color: const Color(0xFF2B99E3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Ask\nCode',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFF7F9F9),
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  height: 1.10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget socialButton({required Widget child}) {
    return Container(
      width: 74,
      height: 40,
      decoration: ShapeDecoration(
        color: const Color(0xFF2B99E3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        shadows: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(child: child),
    );
  }
}
