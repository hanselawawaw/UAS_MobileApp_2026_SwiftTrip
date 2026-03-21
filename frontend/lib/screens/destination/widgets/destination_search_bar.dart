import 'package:flutter/material.dart';

class DestinationSearchBar extends StatelessWidget {
  final VoidCallback? onTap;
  const DestinationSearchBar({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontFamily: 'Cairo',
      fontWeight: FontWeight.w400,
    );

    const hintStyle = TextStyle(
      color: Color(0xFF9E9E9E),
      fontSize: 16,
      fontFamily: 'Cairo',
      fontWeight: FontWeight.w400,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 40,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
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
        child: TextField(
          readOnly: onTap != null,
          onTap: onTap,
          textAlignVertical: TextAlignVertical.center,
          style: textStyle,
          decoration: const InputDecoration(
            hintText: 'Search',
            hintStyle: hintStyle,
            prefixIcon: Icon(Icons.search, color: Color(0xFF9E9E9E), size: 18),
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            isDense: true,
          ),
        ),
      ),
    );
  }
}
