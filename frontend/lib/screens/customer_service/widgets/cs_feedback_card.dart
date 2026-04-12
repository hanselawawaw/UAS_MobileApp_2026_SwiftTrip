import 'package:flutter/material.dart';
import '../models/cs_chat_models.dart';
import 'cs_user_row.dart';

class CsFeedbackCard extends StatelessWidget {
  final CsFeedbackEntry entry;

  const CsFeedbackCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        shadows: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: CsUserRow(
                  username: entry.isAnswered ? 'IT Team CS' : entry.username,
                ),
              ),
              if (entry.isAnswered)
                const Text(
                  'Answered',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Color(0xFF2B99E3),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            entry.date,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: 10,
              height: 2,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            entry.body,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: 12,
              height: 1.67,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
