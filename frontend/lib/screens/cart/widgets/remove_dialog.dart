import 'package:flutter/material.dart';

class RemoveTicketDialog extends StatelessWidget {
  const RemoveTicketDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: 313,
        height: 157,
        decoration: ShapeDecoration(
          gradient: const LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color(0xFFFFCDCD),
              Color(0xFFF6F6F6),
              Color(0xFFF6F6F6),
              Color(0xFFFFCDCD),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x4C000000),
              blurRadius: 20,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            const Text(
              'Are You Sure To Remove \nYour Order?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Cancel Button
                GestureDetector(
                  onTap: () => Navigator.pop(context, false),
                  child: Container(
                    width: 121,
                    height: 37,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: const Color(0xFFFFFFFF),
                    ),
                    child: Center(
                      child: Text(
                        'Cancel',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF999999),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          shadows: [
                            Shadow(
                              offset: const Offset(0, 0),
                              blurRadius: 8,
                              color: Colors.black.withValues(alpha: 0.25),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Delete Button
                GestureDetector(
                  onTap: () => Navigator.pop(context, true),
                  child: Container(
                    width: 121,
                    height: 33,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFE55A5A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
