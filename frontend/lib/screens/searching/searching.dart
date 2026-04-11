import 'package:flutter/material.dart';

import '../../widgets/top_bar.dart';
import '../customer_service/onboarding.dart';

import 'widgets/coupon_section.dart';
import 'widgets/flight_search_card.dart';

class SearchingPage extends StatelessWidget {
  const SearchingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 250,
            child: Image.asset(
              'assets/images/searching/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              TopBar(
                onHamburgerTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OnboardingPage(),
                    ),
                  );
                },
              ),
              const Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 100),
                      FlightSearchCard(),
                      SizedBox(height: 30),
                      CouponSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
