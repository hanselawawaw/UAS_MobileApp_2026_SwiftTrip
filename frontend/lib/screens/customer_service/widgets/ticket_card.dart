import 'package:flutter/material.dart';
import '../models/ticket_item.dart';

class TicketCard extends StatelessWidget {
  final TicketItem item;
  final VoidCallback onReadMore;

  const TicketCard({super.key, required this.item, required this.onReadMore});

  Color get _statusColor {
    switch (item.status) {
      case TicketStatus.pending:
        return const Color(0xFF2B99E3);
      case TicketStatus.solved:
        return const Color(0xFF2B99E3);
      case TicketStatus.replied:
        return const Color(0xFF2B99E3);
    }
  }

  String get _statusLabel {
    switch (item.status) {
      case TicketStatus.pending:
        return 'Pending';
      case TicketStatus.solved:
        return 'Solved';
      case TicketStatus.replied:
        return 'Replied';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 11, 18, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Title Row + Status ───────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          height: 1.67,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Issued: ${item.issuedDate}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                          height: 2,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Status: ',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            height: 2,
                            color: Color(0xFF0C161C),
                          ),
                        ),
                        Text(
                          _statusLabel,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            height: 2,
                            color: _statusColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Ticket is ',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                            height: 2.4,
                            color: Color(0xFF0C161C),
                          ),
                        ),
                        Text(
                          item.isPublic ? 'public' : 'Private',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                            height: 2.4,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            const Divider(color: Color(0x4D000000), thickness: 1, height: 16),

            // ── Preview Text ─────────────────────────────────────────────
            Text(
              item.preview,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 12,
                height: 1.67,
                color: Color(0xFF999999),
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),

            // ── Read More ────────────────────────────────────────────────
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
      ),
    );
  }
}
