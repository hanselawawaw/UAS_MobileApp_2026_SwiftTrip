import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../cart/models/cart_models.dart';
import '../cart/widgets/ticket_card.dart';
import '../../widgets/top_bar.dart';
import '../customer_service/onboarding.dart';
import '../auth/login.dart';
import 'services/history_service.dart';

class HistoryPage extends StatefulWidget {
  final HistoryService? historyService;

  const HistoryPage({super.key, this.historyService});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late final HistoryService _historyService;
  late Future<List<CartTicket>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyService = widget.historyService ?? HistoryService();
    _historyFuture = _historyService.fetchHistory();
  }

  void _redirectToLogin() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopBar(
              showBackButton: true,
              onHamburgerTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OnboardingPage(),
                  ),
                );
              },
            ),
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
              child: FutureBuilder<List<CartTicket>>(
                future: _historyFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (snapshot.hasError) {
                    final error = snapshot.error;
                    if (error is DioException && error.response?.statusCode == 401) {
                      _redirectToLogin();
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final history = snapshot.data ?? [];
                  
                  if (history.isEmpty) {
                    return const Center(
                      child: Text(
                        'No purchase history yet.',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      bottom: 40,
                    ),
                    itemCount: history.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      final ticket = history[index];
                      return TicketCard(
                        ticket: ticket,
                        formatRp: (val) => 'Rp ${val.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                        onDelete: null, // Hide delete button for history
                      );
                    },
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
