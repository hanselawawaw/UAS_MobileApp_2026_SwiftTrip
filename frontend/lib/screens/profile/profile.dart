import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'widgets/profile_card.dart';
import 'widgets/menu_section.dart';
import 'language_screen.dart';
import 'clear_cache_screen.dart';
import 'wishlist_screen.dart';
import 'payment_options_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // ── Top Bar ───────────────────────────────────────────────────────
          _TopBar(),

          // ── Scrollable content ────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── User card ────────────────────────────────────────────
                  const ProfileCard(),
                  const SizedBox(height: 20),

                  // ── Wishlist ─────────────────────────────────────────────
                  MenuSection(
                    items: [
                      MenuItem(
                        icon: Icons.favorite_border,
                        label: 'Wishlist',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const WishlistScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Subscription / Payment / Language ────────────────────
                  MenuSection(
                    items: [
                      MenuItem(
                        icon: Icons.credit_card_outlined,
                        label: 'Subscription Plan',
                        onTap: () {},
                      ),
                      MenuItem(
                        icon: Icons.account_balance_outlined,
                        label: 'Payment Options',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PaymentOptionsScreen(),
                            ),
                          );
                        },
                      ),
                      MenuItem(
                        icon: Icons.language,
                        label: 'Language',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LanguageScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Clear Cache / Log Out ────────────────────────────────
                  MenuSection(
                    items: [
                      MenuItem(
                        icon: Icons.delete_outline,
                        label: 'Clear Cache',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ClearCacheScreen(),
                            ),
                          );
                        },
                      ),
                      MenuItem(
                        icon: Icons.logout,
                        label: 'Log Out',
                        iconColor: Colors.red,
                        labelColor: Colors.black,
                        showArrow: false,
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 100), // padding for CurvedNavigationBar
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TOP BAR  — logo kiri, hamburger kanan
// ─────────────────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 15,
        left: 20,
        right: 20,
        bottom: 15,
      ),
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/swifttrip_logo.svg', height: 30),
          const Spacer(),
          SvgPicture.asset('assets/icons/hamburger.svg', height: 30),
        ],
      ),
    );
  }
}