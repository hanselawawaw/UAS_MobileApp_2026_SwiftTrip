import 'package:flutter/material.dart';
import '../models/recent_question.dart';

class RecentCard extends StatelessWidget {
  final RecentQuestion question;
  final VoidCallback? onReadMore;
  final double cardWidth;

  const RecentCard({
    super.key,
    required this.question,
    this.onReadMore,
    this.cardWidth = 350,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
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
          // ── Username ───────────────────────────────────────────────────
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
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
                ),
              ),
              const SizedBox(width: 8),
              Text(
                question.username,
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
          const SizedBox(height: 8),

          // ── Question ───────────────────────────────────────────────────
          Text(
            question.question,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: 10,
              height: 2,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),

          // ── Read more ──────────────────────────────────────────────────
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: onReadMore,
              child: const Text(
                'Read more >',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  height: 2,
                  color: Color(0xFF2B99E3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
