import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swifttrip_frontend/screens/main/main_screen.dart';
import '../home/home.dart';
import '../cart/cart.dart';
import '../searching/searching.dart';
import '../destination/destination.dart';
import '../profile/profile.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MODEL
// ─────────────────────────────────────────────────────────────────────────────

class _PlanData {
  final String id;
  final String name;
  final Color gradientColor;
  final String buttonLabel;
  final bool isCurrent;
  final List<_PlanFeature> features;

  const _PlanData({
    required this.id,
    required this.name,
    required this.gradientColor,
    required this.buttonLabel,
    required this.isCurrent,
    required this.features,
  });
}

class _PlanFeature {
  final String text;
  final bool isHighlighted;

  const _PlanFeature({required this.text, this.isHighlighted = false});
}

// ─────────────────────────────────────────────────────────────────────────────
// DATA
// ─────────────────────────────────────────────────────────────────────────────

const List<_PlanData> _plans = [
  _PlanData(
    id: 'plan_golden',
    name: 'Golden',
    gradientColor: Color(0xFFEAB308),
    buttonLabel: 'Buy Golden Plan',
    isCurrent: false,
    features: [
      _PlanFeature(
        text: 'Priority AI Travel Assistant (24/7 real-time support)',
        isHighlighted: true,
      ),
      _PlanFeature(
        text: 'Exclusive mid-tier discounts on flights & hotels (up to 15%)',
        isHighlighted: true,
      ),
      _PlanFeature(
        text: 'Flexible booking options with low-fee reschedule & cancellation',
      ),
      _PlanFeature(text: 'Early access to flash sales & limited travel deals'),
      _PlanFeature(text: 'Earn 2x loyalty points on every transaction'),
    ],
  ),
  _PlanData(
    id: 'plan_free',
    name: 'Free Plan',
    gradientColor: Color(0xFF84CC16),
    buttonLabel: 'Currently Used',
    isCurrent: true,
    features: [
      _PlanFeature(
        text: 'Standard AI Travel Assistant (best-effort support)',
        isHighlighted: true,
      ),
      _PlanFeature(text: 'Access to basic discounts (up to 5%)'),
      _PlanFeature(text: 'Standard booking with regular fees'),
      _PlanFeature(text: 'Standard access to sales and deals'),
      _PlanFeature(text: 'Earn 1x loyalty points on every transaction'),
    ],
  ),
  _PlanData(
    id: 'plan_premium',
    name: 'Premium',
    gradientColor: Color(0xFFEF4444),
    buttonLabel: 'Buy Premium Plan',
    isCurrent: false,
    features: [
      _PlanFeature(
        text: 'Premium AI Travel Assistant (24/7 priority support)',
        isHighlighted: true,
      ),
      _PlanFeature(
        text: 'Top-tier discounts on flights & hotels (up to 25%)',
        isHighlighted: true,
      ),
      _PlanFeature(
        text:
            'Most flexible booking with waived reschedule & cancellation fees',
        isHighlighted: true,
      ),
      _PlanFeature(text: 'Priority access to all sales & limited deals'),
      _PlanFeature(text: 'Earn 3x loyalty points on every transaction'),
      _PlanFeature(text: 'Complimentary travel insurance coverage'),
    ],
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// SUBSCRIPTION PLAN SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class SubscriptionPlanScreen extends StatefulWidget {
  const SubscriptionPlanScreen({super.key});

  @override
  State<SubscriptionPlanScreen> createState() => _SubscriptionPlanScreenState();
}

class _SubscriptionPlanScreenState extends State<SubscriptionPlanScreen> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    // Sort plans so the active card always renders last (on top)
    List<MapEntry<int, _PlanData>> sortedPlans = _plans
        .asMap()
        .entries
        .toList();
    sortedPlans.sort((a, b) {
      if (a.key == _currentIndex) return 1;
      if (b.key == _currentIndex) return -1;
      return 0;
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0F1F3D),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SubTopBar(),
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 8, 24, 0),
            child: Text(
              'Subscription Plan',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Divider(color: Color(0xFF0E121E), height: 24),
          ),

          // ── Stacked Cards Layout ─────────────────────────────────────────
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: sortedPlans.map((entry) {
                final int i = entry.key;
                final plan = entry.value;
                final bool isActive = i == _currentIndex;

                int diff = i - _currentIndex;
                if (diff < -1) diff += _plans.length;
                if (diff > 1) diff -= _plans.length;

                // 1.3 pushes the rear cards to overflow the screen edges
                final alignment = Alignment(diff * 1.3, 0.0);

                return AnimatedAlign(
                  key: ValueKey(plan.id),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  alignment: alignment,
                  child: AnimatedScale(
                    scale: isActive ? 1.0 : 0.85,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                    child: GestureDetector(
                      onTap: () {
                        if (!isActive) setState(() => _currentIndex = i);
                      },
                      child: _PlanCard(plan: plan, isActive: isActive),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 20),
          _BottomNavBar(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SUBSCRIPTION TOP BAR
// ─────────────────────────────────────────────────────────────────────────────

class _SubTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 15,
        left: 20,
        right: 20,
        bottom: 15,
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/swifttrip_logo.svg',
            height: 30,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.chevron_left,
              size: 30,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PLAN CARD
// ─────────────────────────────────────────────────────────────────────────────

class _PlanCard extends StatelessWidget {
  final _PlanData plan;
  final bool isActive;

  const _PlanCard({required this.plan, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      width: 280,
      height: 534,
      decoration: BoxDecoration(
        color: const Color(0xFF15233E),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            // White outer glow
            color: Colors.white.withOpacity(isActive ? 0.25 : 0.1),
            blurRadius: 15,
            spreadRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Top Gradient Block (No Text) ─────────────────────────────────
          Container(
            height: 60,
            width: double.infinity,
            decoration: ShapeDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  plan.gradientColor.withOpacity(0.7),
                  plan.gradientColor,
                  plan.gradientColor,
                  plan.gradientColor.withOpacity(0.6),
                ],
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              shadows: [
                BoxShadow(
                  color: plan.gradientColor,
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),

          // ── Plan Name ────────────────────────────────────────────────────
          const SizedBox(height: 15),
          Text(
            plan.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),

          // ── Features List ────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: plan.features
                    .map(
                      (f) => _FeatureRow(
                        feature: f,
                        accentColor: plan.gradientColor,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),

          // ── Confirm Button (Gradient) ────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: GestureDetector(
              onTap: () {
                // TODO: Pass plan.id to backend for subscription upgrade
              },
              child: Container(
                width: 228,
                height: 30,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: plan.isCurrent
                          ? Colors.transparent
                          : plan.gradientColor,
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Container(
                  width: 228,
                  height: 25,
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: plan.isCurrent
                          ? [
                              const Color(0x401A294A),
                              const Color(0xFF1A294A),
                              const Color(0x401A294A),
                            ]
                          : [
                              plan.gradientColor.withOpacity(0.66),
                              plan.gradientColor,
                              plan.gradientColor.withOpacity(0.66),
                            ],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: plan.isCurrent
                          ? const BorderSide(color: Colors.white24, width: 1)
                          : BorderSide.none,
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x26000000),
                        blurRadius: 20,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    plan.buttonLabel,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FEATURE ROW
// ─────────────────────────────────────────────────────────────────────────────

class _FeatureRow extends StatelessWidget {
  final _PlanFeature feature;
  final Color accentColor;

  const _FeatureRow({required this.feature, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: OverflowBox(
              maxWidth: 55,
              maxHeight: 55,
              child: feature.isHighlighted
                  ? SvgPicture.string(
                      '''<svg width="60" height="60" viewBox="0 0 60 60" fill="none" xmlns="http://www.w3.org/2000/svg">
<g filter="url(#filter0_d_478_1279)">
<path d="M36.5124 22.5924V19.5024C36.5124 18.9524 36.0624 18.5024 35.5124 18.5024H32.4224L30.2124 16.2924C30.1199 16.1997 30.01 16.1262 29.8891 16.076C29.7681 16.0258 29.6384 16 29.5074 16C29.3765 16 29.2468 16.0258 29.1258 16.076C29.0048 16.1262 28.895 16.1997 28.8024 16.2924L26.5924 18.5024H23.5024C22.9524 18.5024 22.5024 18.9524 22.5024 19.5024V22.5924L20.2924 24.8024C20.1997 24.895 20.1262 25.0048 20.076 25.1258C20.0258 25.2468 20 25.3765 20 25.5074C20 25.6384 20.0258 25.7681 20.076 25.8891C20.1262 26.01 20.1997 26.1199 20.2924 26.2124L22.5024 28.4224V31.5124C22.5024 32.0624 22.9524 32.5124 23.5024 32.5124H26.5924L28.8024 34.7224C29.0024 34.9224 29.2524 35.0124 29.5124 35.0124C29.7724 35.0124 30.0224 34.9124 30.2224 34.7224L32.4324 32.5124H35.5224C36.0724 32.5124 36.5224 32.0624 36.5224 31.5124V28.4224L38.7324 26.2124C38.8251 26.1199 38.8987 26.01 38.9489 25.8891C38.9991 25.7681 39.0249 25.6384 39.0249 25.5074C39.0249 25.3765 38.9991 25.2468 38.9489 25.1258C38.8987 25.0048 38.8251 24.895 38.7324 24.8024L36.5224 22.5924H36.5124ZM28.0984 29.9224L24.8024 26.38L26.5173 24.5368L28.0862 26.2231L32.0876 21.9224L33.8024 23.7656L28.0741 29.9224H28.0984Z" fill="#FFCC00"/>
</g>
<defs>
<filter id="filter0_d_478_1279" x="0" y="0" width="59.0249" height="59.0125" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
<feFlood flood-opacity="0" result="BackgroundImageFix"/>
<feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>
<feOffset dy="4"/>
<feGaussianBlur stdDeviation="10"/>
<feComposite in2="hardAlpha" operator="out"/>
<feColorMatrix type="matrix" values="0 0 0 0 1 0 0 0 0 1 0 0 0 0 0 0 0 0 1 0"/>
<feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_478_1279"/>
<feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow_478_1279" result="shape"/>
</filter>
</defs>
</svg>''',
                      width: 65,
                      height: 65,
                    )
                  : SvgPicture.string(
                      '''<svg width="36" height="36" viewBox="0 0 36 36" fill="none" xmlns="http://www.w3.org/2000/svg">
<g filter="url(#filter0_d_478_1261)">
<path d="M18 6C13.5817 6 10 9.58175 10 14C10 18.4185 13.5817 22 18 22C22.4185 22 26 18.4185 26 14C26 9.58175 22.4185 6 18 6ZM18 21.0157C14.1403 21.0157 11 17.8597 11 14C11 10.1402 14.1403 6.99997 18 6.99997C21.8597 6.99997 25 10.1402 25 14C25 17.8597 21.8597 21.0157 18 21.0157ZM21.1927 11.0728L16.499 15.796L14.3852 13.6823C14.19 13.487 13.8735 13.487 13.678 13.6823C13.4827 13.8775 13.4827 14.194 13.678 14.3892L16.1527 16.8643C16.348 17.0592 16.6645 17.0592 16.86 16.8643C16.8825 16.8418 16.9018 16.8172 16.9193 16.7917L21.9003 11.78C22.0953 11.5847 22.0953 11.2682 21.9003 11.0728C21.7048 10.8775 21.3883 10.8775 21.1927 11.0728Z" fill="white"/>
</g>
<defs>
<filter id="filter0_d_478_1261" x="0" y="0" width="36" height="36" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
<feFlood flood-opacity="0" result="BackgroundImageFix"/>
<feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>
<feOffset dy="4"/>
<feGaussianBlur stdDeviation="5"/>
<feComposite in2="hardAlpha" operator="out"/>
<feColorMatrix type="matrix" values="0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 1 0"/>
<feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_478_1261"/>
<feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow_478_1261" result="shape"/>
</filter>
</defs>
</svg>''',
                      width: 40,
                      height: 40,
                    ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              feature.text,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 11,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BOTTOM NAV BAR
// ─────────────────────────────────────────────────────────────────────────────
class _BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F1F3D),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavItem(
            svgString:
                '''<svg width="28" height="32" viewBox="0 0 28 32" fill="#FFFFFF" xmlns="http://www.w3.org/2000/svg">
<path d="M3.5 28.4444H8.75V17.7778H19.25V28.4444H24.5V12.4444L14 4.44444L3.5 12.4444V28.4444ZM0 32V10.6667L14 0L28 10.6667V32H15.75V21.3333H12.25V32H0Z" fill="white"/>
</svg>
''',
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainScreen(initialIndex: 0),
                ), // Home
                (route) => false,
              );
            },
          ),
          _NavItem(
            svgString:
                '''<svg width="30" height="30" viewBox="0 0 30 30" fill="#FFFFFF" xmlns="http://www.w3.org/2000/svg">
<path d="M24 24C24.7956 24 25.5587 24.3161 26.1213 24.8787C26.6839 25.4413 27 26.2044 27 27C27 27.7956 26.6839 28.5587 26.1213 29.1213C25.5587 29.6839 24.7956 30 24 30C23.2044 30 22.4413 29.6839 21.8787 29.1213C21.3161 28.5587 21 27.7956 21 27C21 25.335 22.335 24 24 24ZM0 0H4.905L6.315 3H28.5C28.8978 3 29.2794 3.15804 29.5607 3.43934C29.842 3.72064 30 4.10218 30 4.5C30 4.755 29.925 5.01 29.82 5.25L24.45 14.955C23.94 15.87 22.95 16.5 21.825 16.5H10.65L9.3 18.945L9.255 19.125C9.255 19.2245 9.29451 19.3198 9.36483 19.3902C9.43516 19.4605 9.53054 19.5 9.63 19.5H27V22.5H9C8.20435 22.5 7.44129 22.1839 6.87868 21.6213C6.31607 21.0587 6 20.2956 6 19.5C6 18.975 6.135 18.48 6.36 18.06L8.4 14.385L3 3H0V0ZM9 24C9.79565 24 10.5587 24.3161 11.1213 24.8787C11.6839 25.4413 12 26.2044 12 27C12 27.7956 11.6839 28.5587 11.1213 29.1213C10.5587 29.6839 9.79565 30 9 30C8.20435 30 7.44129 29.6839 6.87868 29.1213C6.31607 28.5587 6 27.7956 6 27C6 25.335 7.335 24 9 24ZM22.5 13.5L26.67 6H7.71L11.25 13.5H22.5Z" fill="white"/>
</svg>
''',
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainScreen(initialIndex: 1),
                ), // Cart
                (route) => false,
              );
            },
          ),
          _NavItem(
            svgString:
                '''<svg width="31" height="31" viewBox="0 0 31 31" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M27.5059 1.25C28.1003 1.25246 28.6695 1.48983 29.0898 1.91016C29.5102 2.33048 29.7475 2.89972 29.75 3.49414C29.7524 4.0869 29.5211 4.65668 29.1064 5.08008L23.2559 10.9287C22.9602 11.2244 22.8319 11.6486 22.9141 12.0586L26.082 27.8184C26.096 27.8878 26.0901 28.1079 25.8643 28.458C25.6489 28.7917 25.3114 29.1136 24.9443 29.3291C24.5608 29.5542 24.2845 29.5843 24.165 29.5654C24.1447 29.5622 24.0433 29.574 23.9258 29.2725L19.29 17.375C19.1368 16.9818 18.7958 16.6923 18.3828 16.6055C18.0213 16.5296 17.6471 16.6176 17.3594 16.8408L17.2422 16.9453L11.2227 22.9648C10.9627 23.2248 10.8298 23.5858 10.8604 23.9521C11.0122 25.775 11.0688 26.7203 10.8721 27.5205C10.7669 27.9482 10.574 28.3726 10.1904 28.8936L7.32031 24.1084C7.24123 23.9766 7.13897 23.8607 7.01855 23.7666L6.8916 23.6797L2.10547 20.8086C2.62664 20.4247 3.0517 20.2322 3.47949 20.127C4.27933 19.9302 5.22462 19.987 7.04688 20.1396C7.41341 20.1704 7.77503 20.0374 8.03516 19.7773L14.0547 13.7598C14.3532 13.4613 14.4812 13.0323 14.3945 12.6191C14.3078 12.2061 14.0183 11.8642 13.625 11.7109L1.72754 7.07422C1.4262 6.9568 1.43786 6.8556 1.43457 6.83496C1.4156 6.71541 1.44578 6.43939 1.6709 6.05566C1.88636 5.68848 2.20844 5.35099 2.54199 5.13574C2.89191 4.91005 3.11151 4.90402 3.18066 4.91797H3.18164L18.9404 8.08594C19.3506 8.16837 19.7755 8.03994 20.0713 7.74414L25.916 1.89746C26.3398 1.48056 26.9114 1.24757 27.5059 1.25Z" stroke="white" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''',
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainScreen(initialIndex: 2),
                ), // Destination
                (route) => false,
              );
            },
          ),
          _NavItem(
            svgString:
                '''<svg width="34" height="30" viewBox="0 0 34 30" fill="#FFFFFF" xmlns="http://www.w3.org/2000/svg">
<path d="M34 30H0V26.6667H1.7V1.66667C1.7 1.22464 1.87911 0.800716 2.19792 0.488155C2.51673 0.175595 2.94913 0 3.4 0H27.2C27.6509 0 28.0833 0.175595 28.4021 0.488155C28.7209 0.800716 28.9 1.22464 28.9 1.66667V10H32.3V26.6667H34V30ZM25.5 26.6667H28.9V13.3333H18.7V26.6667H22.1V16.6667H25.5V26.6667ZM25.5 10V3.33333H5.1V26.6667H15.3V10H25.5ZM8.5 13.3333H11.9V16.6667H8.5V13.3333ZM8.5 20H11.9V23.3333H8.5V20ZM8.5 6.66667H11.9V10H8.5V6.66667Z" fill="white"/>
</svg>
''',
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainScreen(initialIndex: 4),
                ), // Profile
                (route) => false,
              );
            },
          ),
          _NavItem(
            svgString:
                '''<svg width="30" height="31" viewBox="0 0 30 31" fill="#FFFFFF" xmlns="http://www.w3.org/2000/svg">
<path d="M4.46582 23.4248C5.65289 24.5417 7.00374 25.4674 8.47461 26.1621C10.369 27.0569 12.4182 27.5489 14.5 27.6152V30.4922C12.0222 30.4251 9.58105 29.8437 7.3252 28.7783C5.06271 27.7098 3.03685 26.1792 1.37012 24.2812L2.22266 23.5303L3.76465 24.001L4.24902 24.1494L4.39062 23.6631C4.41395 23.583 4.43896 23.5034 4.46582 23.4248ZM25.5332 23.4258C25.5602 23.5046 25.586 23.5845 25.6094 23.665L25.751 24.1514L26.2354 24.0029L27.7773 23.5312L28.6309 24.2812C26.9641 26.1789 24.9372 27.7098 22.6748 28.7783C20.4189 29.8437 17.9778 30.4251 15.5 30.4922V27.6152C17.5818 27.5489 19.631 27.0569 21.5254 26.1621C22.9958 25.4676 24.3464 24.5423 25.5332 23.4258ZM1.09863 23.1875L0.791992 23.459L0.724609 23.5176L0.553711 23.3145L0.630859 23.0449L1.09863 23.1875ZM29.4453 23.3145L29.2764 23.5176L28.9824 23.2588L28.9014 23.1875L29.3682 23.0449L29.4453 23.3145ZM26.8955 22.7539L26.8945 22.7549L26.4082 22.9043C26.3756 22.8184 26.3408 22.7335 26.3047 22.6494C26.3752 22.5732 26.4446 22.4957 26.5137 22.418L26.8955 22.7539ZM3.69336 22.6484C3.65744 22.7322 3.62322 22.8169 3.59082 22.9023L3.10449 22.7539H3.10547L3.10449 22.7529L3.48633 22.418C3.55499 22.4952 3.62329 22.5727 3.69336 22.6484ZM8.83789 18.8955C7.68609 18.991 6.58061 19.417 5.65039 20.1279C5.075 20.5677 4.58343 21.1038 4.19336 21.709C4.10067 21.6039 4.00882 21.4976 3.91895 21.3896L3.58984 20.9951L3.2041 21.334L1.98047 22.4111L0.923828 22.0879C1.51726 20.3856 2.58633 18.8985 4.00098 17.8164C5.41019 16.7385 7.0934 16.1156 8.83789 16.0156V18.8955ZM21.1621 16.0156C22.9062 16.116 24.5892 16.7386 25.998 17.8164C27.4125 18.8986 28.4816 20.3862 29.0752 22.0879L28.0195 22.4111L26.7959 21.334L26.4102 20.9951L26.0811 21.3896C25.9905 21.4985 25.8972 21.605 25.8037 21.7109C24.7881 20.1385 23.1045 19.0553 21.1621 18.8955V16.0156ZM20.1621 16V18.875H9.83789V16H20.1621ZM12.6641 6.3125C12.7579 6.7694 12.979 7.19384 13.3076 7.53125C13.6354 7.86769 14.0504 8.09595 14.5 8.19434V11.0996C13.3183 10.9812 12.2045 10.4459 11.3545 9.57324C10.5002 8.69605 9.97417 7.54148 9.86133 6.3125H12.6641ZM20.1387 6.3125C20.0258 7.54148 19.4998 8.69605 18.6455 9.57324C17.7955 10.4459 16.6817 10.9812 15.5 11.0996V8.19434C15.9496 8.09595 16.3646 7.86769 16.6924 7.53125C17.021 7.19384 17.2421 6.7694 17.3359 6.3125H20.1387ZM15.5 0.524414C16.6818 0.642758 17.7954 1.17907 18.6455 2.05176C19.4998 2.92895 20.0258 4.08352 20.1387 5.3125H17.3359C17.2421 4.8556 17.021 4.43116 16.6924 4.09375C16.3646 3.75726 15.9496 3.52805 15.5 3.42969V0.524414ZM14.5 3.42969C14.0504 3.52805 13.6354 3.75726 13.3076 4.09375C12.979 4.43116 12.7579 4.8556 12.6641 5.3125H9.86133C9.97417 4.08352 10.5002 2.92895 11.3545 2.05176C12.2046 1.17907 13.3182 0.642757 14.5 0.524414V3.42969Z" fill="white" stroke="white"/>
</svg>
''',
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainScreen(initialIndex: 4),
                ), // Profile
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String svgString;
  final VoidCallback onTap;

  const _NavItem({required this.svgString, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.string(svgString, width: 28, height: 28),
    );
  }
}
