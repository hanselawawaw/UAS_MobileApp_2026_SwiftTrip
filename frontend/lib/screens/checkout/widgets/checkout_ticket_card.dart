import 'package:flutter/material.dart';
import '../models/ticket_model.dart';

class CheckoutTicketCard extends StatelessWidget {
  final TicketModel ticket;

  const CheckoutTicketCard({
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
          // ── HEADER BAR ───────────────────────────────────────────────────
          Container(
            width: double.infinity,
            height: 30.50,
            padding: const EdgeInsets.symmetric(horizontal: 17),
            decoration: const ShapeDecoration(
              color: Color(0xFF0098FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
            ),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Train Ticket',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          // ── CLASS LABEL ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 6, bottom: 6),
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

          // ── FROM / TO ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _TicketLabelValue(
                  label: 'FROM',
                  value: ticket.from,
                  isLarge: true,
                ),
                _TicketLabelValue(
                  label: 'TO',
                  value: ticket.to,
                  isLarge: true,
                ),
                const SizedBox(width: 20),
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

          // ── ROW 1: DATE / DEPARTURE / ARRIVE ─────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _TicketLabelValue(label: 'DATE', value: ticket.date),
                _TicketLabelValue(label: 'DEPARTURE', value: ticket.departureTime),
                _TicketLabelValue(label: 'ARRIVE', value: ticket.arrivalTime),
              ],
            ),
          ),

          // ── ROW 2: TRAIN / CARRIAGE / SEAT ───────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 4, 15, 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _TicketLabelValue(label: 'TRAIN', value: ticket.trainNumber),
                _TicketLabelValue(label: 'CARRIAGE', value: ticket.carriage),
                _TicketLabelValue(label: 'SEAT', value: ticket.seatNumber),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketLabelValue extends StatelessWidget {
  final String label;
  final String value;
  final bool isLarge;

  const _TicketLabelValue({
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
