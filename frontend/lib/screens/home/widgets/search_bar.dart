import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../room_chat.dart';
import '../../../providers/language_provider.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LanguageProvider>();
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RoomChatPage()),
          );
        },
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
                child: Text(
                  provider.translate('search'),
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.40),
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SvgPicture.asset('assets/icons/magnifier.svg', height: 18),
            ],
          ),
        ),
      ),
    );
  }
}
