import 'package:flutter/material.dart';
import 'package:swifttrip_frontend/screens/customer_service/onboarding.dart';
import '../../widgets/top_bar.dart';
import '../auth/login.dart';
import 'widgets/profile_card.dart';
import 'widgets/menu_section.dart';
import 'widgets/menu_item.dart';
import 'language.dart';
import 'clear_cache.dart';
import 'wishlist.dart';
import 'subscription_plan.dart';
import 'profile_edit_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ProfileCardState> _profileCardKey = GlobalKey<ProfileCardState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // ── Top Bar ───────────────────────────────────────────────────────
          TopBar(
            onHamburgerTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OnboardingPage()),
            ),
          ),

          // ── Scrollable content ────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── User card ────────────────────────────────────────────
                  const SizedBox(height: 30),
                  ProfileCard(key: _profileCardKey),
                  const SizedBox(height: 50),

                  // ── Edit pProfile / Wishlist ─────────────────────────────────────────────
                  MenuSection(
                    items: [
                      MenuItem(
                        icon: Icons.edit,
                        label: 'Edit Profile',
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProfileEditScreen(),
                            ),
                          );
                          if (result == true) {
                            _profileCardKey.currentState?.refresh();
                          }
                        },
                      ),
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
                  const SizedBox(height: 30),

                  // ── Subscription / Payment / Language ────────────────────
                  MenuSection(
                    items: [
                      MenuItem(
                        icon: Icons.credit_card_outlined,
                        label: 'Subscription Plan',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SubscriptionPlanScreen(),
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
                  const SizedBox(height: 30),

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
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
