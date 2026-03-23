import 'package:flutter/material.dart';
import '../models/ticket_model.dart';

class PaymentTicketCard extends StatelessWidget {
  final TicketModel ticket;

  const PaymentTicketCard({
    super.key,
    required this.ticket,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
          // Faint barcode-style header strip
          Container(
            width: double.infinity,
            height: 22,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFEEEEEE),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            alignment: Alignment.centerLeft,
            child: const Text(
              'TRAIN TICKET  ·  NO. 123 IN NAGASMSONASD',
              style: TextStyle(
                color: Color(0xFFAAAAAA),
                fontSize: 8,
                fontFamily: 'Cairo',
                letterSpacing: 0.5,
              ),
            ),
          ),

          // ── CLASS LABEL ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 10, bottom: 6),
            child: Text(
              ticket.classType.toUpperCase(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const Divider(
            height: 1,
            thickness: 1,
            indent: 13,
            endIndent: 13,
            color: Color(0x4D000000),
          ),

          // ── FROM / TO ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                _LabelValue(label: 'FROM', value: ticket.from, isLarge: true),
                const SizedBox(width: 48),
                _LabelValue(label: 'TO', value: ticket.to, isLarge: true),
              ],
            ),
          ),

          const Divider(
            height: 1,
            thickness: 1,
            indent: 13,
            endIndent: 13,
            color: Color(0x4D000000),
          ),

          // ── ROW 1: DATE / DEPARTURE / ARRIVE ───────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _LabelValue(label: 'DATE', value: ticket.date),
                _LabelValue(label: 'DEPARTURE', value: ticket.departureTime),
                _LabelValue(label: 'ARRIVE', value: ticket.arrivalTime),
              ],
            ),
          ),

          // ── ROW 2: TRAIN / CARRIAGE / SEAT ─────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 4, 15, 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _LabelValue(label: 'TRAIN', value: ticket.trainNumber),
                _LabelValue(label: 'CARRIAGE', value: ticket.carriage),
                _LabelValue(label: 'SEAT', value: ticket.seatNumber),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LabelValue extends StatelessWidget {
  final String label;
  final String value;
  final bool isLarge;

  const _LabelValue({
    required this.label,
    required this.value,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 10,
            fontFamily: 'Cairo',
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.black,
            fontSize: isLarge ? 16 : 10,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }
}
