import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 270,
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const ShapeDecoration(
          color: Colors.white,
          shape: StadiumBorder(),
          shadows: [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 20,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Let AI Help Your Journey',
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.40),
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            SvgPicture.asset('assets/icons/magnifier.svg', height: 18),
          ],
        ),
      ),
    );
  }
}
