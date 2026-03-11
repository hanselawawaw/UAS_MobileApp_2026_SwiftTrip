import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const _chatIconSvg = '''
<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M2.61279 28.7402V5.22554C2.61279 4.50703 2.86884 3.89217 3.38094 3.38094C3.89304 2.86971 4.5079 2.61366 5.22554 2.61279H26.1275C26.846 2.61279 27.4613 2.86884 27.9734 3.38094C28.4855 3.89304 28.7411 4.5079 28.7402 5.22554V20.902C28.7402 21.6205 28.4846 22.2358 27.9734 22.7479C27.4622 23.26 26.8469 23.5156 26.1275 23.5148H7.83828L2.61279 28.7402ZM7.83828 18.2893H18.2893V15.6765H7.83828V18.2893ZM7.83828 14.3701H23.5147V11.7574H7.83828V14.3701ZM7.83828 10.451H23.5147V7.83828H7.83828V10.451Z" fill="white"/>
</svg>
''';

class FloatingButtons extends StatelessWidget {
  const FloatingButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: ShapeDecoration(
            color: const Color(0xFF0B4882),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Center(
            child: SvgPicture.string(_chatIconSvg, width: 28, height: 28),
          ),
        ),
      ],
    );
  }
}
