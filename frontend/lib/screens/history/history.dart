import 'package:flutter/material.dart';
import '../../widgets/top_bar.dart';
import '../cart/cart.dart'; // Assuming TicketCard and CartTicket live here

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TopBar(showBackButton: true),
            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'History',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  bottom:
                      40, // Reduced padding since there is no navbar blocking it
                ),
                itemCount: 3,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  return TicketCard(
                    ticket: CartTicket(
                      type: 'Train Ticket',
                      bookingId: 'ID-HISTORY${index}123',
                      classLabel: 'ECONOMY CLASS',
                      from: 'Jakarta',
                      to: 'Bali',
                      date: '10/12/2025',
                      departure: '08:00',
                      arrive: '10:00',
                      train: 'Argo Bromo',
                      carriage: '3',
                      seat: '12A',
                      priceRp: 500000,
                    ),
                    formatRp: (val) => 'Rp. $val',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
