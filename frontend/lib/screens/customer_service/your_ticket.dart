import 'package:flutter/material.dart';
import '../../widgets/top_bar.dart';
import 'onboarding.dart';
import 'cs_chat.dart';
import 'models/ticket_item.dart';
import 'widgets/cs_search_bar.dart';
import 'widgets/ticket_card.dart';
import 'services/customer_service_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// YOUR TICKET PAGE
// ─────────────────────────────────────────────────────────────────────────────

class YourTicketPage extends StatefulWidget {
  const YourTicketPage({super.key});

  @override
  State<YourTicketPage> createState() => _YourTicketPageState();
}

class _YourTicketPageState extends State<YourTicketPage> {
  final TextEditingController _searchController = TextEditingController();
  final CustomerServiceService _service = CustomerServiceService();

  List<TicketItem> _tickets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  Future<void> _loadTickets() async {
    final tickets = await _service.getTickets();
    if (mounted) {
      setState(() {
        _tickets = tickets;
        _isLoading = false;
      });
    }
  }

  List<TicketItem> get _filteredTickets {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) return _tickets;
    return _tickets.where((ticket) {
      return ticket.title.toLowerCase().contains(query) ||
          ticket.preview.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // ── Top Bar ────────────────────────────────────────────────────
          TopBar(
            showBackButton: true,
            showHamburger: true,
            onHamburgerTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OnboardingPage()),
              );
            },
          ),

          // ── Search Section ─────────────────────────────────────────────
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CsSearchBar(
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 24),

                        // ── Ticket List ──────────────────────────────────────────
                        const Text(
                          'Your Support Ticket:',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),

                        ..._filteredTickets.map((ticket) => Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: TicketCard(
                                item: ticket,
                                onReadMore: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CsChatPage(
                                        ticketId: ticket.id,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
