import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MODEL
// ─────────────────────────────────────────────────────────────────────────────

class _PlanData {
  final String name;
  final Color gradientColor;
  final String buttonLabel;
  final bool isCurrent;
  final List<_PlanFeature> features;

  const _PlanData({
    required this.name,
    required this.gradientColor,
    required this.buttonLabel,
    required this.isCurrent,
    required this.features,
  });
}

class _PlanFeature {
  final String text;
  final bool isHighlighted; // gold icon vs normal check

  const _PlanFeature({required this.text, this.isHighlighted = false});
}

// ─────────────────────────────────────────────────────────────────────────────
// DATA
// ─────────────────────────────────────────────────────────────────────────────

const List<_PlanData> _plans = [
  _PlanData(
    name: 'Golden',
    gradientColor: Color(0xFFFFD700),
    buttonLabel: 'Buy Golden',
    isCurrent: false,
    features: [
      _PlanFeature(text: 'Chat ke Ai', isHighlighted: true),
      _PlanFeature(text: 'Lorem ipsum dolor sit amet'),
      _PlanFeature(text: 'Lorem ipsum dolor sit amet'),
      _PlanFeature(text: 'Lorem ipsum dolor sit amet'),
      _PlanFeature(text: 'Lorem ipsum dolor sit amet'),
    ],
  ),
  _PlanData(
    name: 'Free Plan',
    gradientColor: Color(0xFF4ADE80),
    buttonLabel: 'Currently Used',
    isCurrent: true,
    features: [
      _PlanFeature(text: 'Chat ke Ai', isHighlighted: true),
      _PlanFeature(text: 'Lorem ipsum dolor sit amet'),
      _PlanFeature(text: 'Lorem ipsum dolor sit amet'),
      _PlanFeature(text: 'Lorem ipsum dolor sit amet'),
      _PlanFeature(text: 'Lorem ipsum dolor sit amet'),
    ],
  ),
  _PlanData(
    name: 'Premium',
    gradientColor: Color(0xFFEF4444),
    buttonLabel: 'Buy Premium',
    isCurrent: false,
    features: [
      _PlanFeature(text: 'Chat ke Ai', isHighlighted: true),
      _PlanFeature(text: 'Lorem ipsum dolor sit amet'),
      _PlanFeature(text: 'Lorem ipsum dolor sit amet'),
      _PlanFeature(text: 'Lorem ipsum dolor sit amet'),
      _PlanFeature(text: 'Lorem ipsum dolor sit amet'),
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
  int _currentIndex = 1; // Free Plan default (center)
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _currentIndex,
      viewportFraction: 0.75, // show partial cards on sides
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1F3D),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top Bar ────────────────────────────────────────────────────
          _SubTopBar(),

          // ── Title ──────────────────────────────────────────────────────
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
            child: Divider(color: Colors.white24, height: 24),
          ),

          // ── Cards carousel ─────────────────────────────────────────────
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _plans.length,
              onPageChanged: (i) => setState(() => _currentIndex = i),
              itemBuilder: (_, i) {
                final isActive = i == _currentIndex;
                return AnimatedScale(
                  scale: isActive ? 1.0 : 0.88,
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOutCubic,
                  child: AnimatedOpacity(
                    opacity: isActive ? 1.0 : 0.6,
                    duration: const Duration(milliseconds: 350),
                    child: GestureDetector(
                      onTap: () => _goToPage(i),
                      child: _PlanCard(
                        plan: _plans[i],
                        isActive: isActive,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TOP BAR
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
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF162040),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isActive
              ? plan.gradientColor.withOpacity(0.5)
              : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: plan.gradientColor.withOpacity(0.25),
                  blurRadius: 30,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Column(
        children: [
          // ── Gradient top banner ───────────────────────────────────────
          Container(
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  plan.gradientColor,
                  plan.gradientColor.withOpacity(0.0),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
          ),

          // ── Plan name ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              plan.name,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),

          // ── Features ──────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: plan.features
                    .map((f) => _FeatureRow(feature: f))
                    .toList(),
              ),
            ),
          ),

          // ── Button ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                height: 46,
                decoration: BoxDecoration(
                  color: plan.isCurrent
                      ? Colors.transparent
                      : plan.gradientColor,
                  borderRadius: BorderRadius.circular(30),
                  border: plan.isCurrent
                      ? Border.all(color: Colors.white24, width: 1)
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  plan.buttonLabel,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: plan.isCurrent ? Colors.white54 : Colors.white,
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

  const _FeatureRow({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          // Icon
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: feature.isHighlighted
                  ? const Color(0xFFFFD700)
                  : Colors.transparent,
              shape: BoxShape.circle,
              border: feature.isHighlighted
                  ? null
                  : Border.all(color: Colors.white38, width: 1.5),
            ),
            child: Icon(
              feature.isHighlighted
                  ? Icons.chat_bubble_outline
                  : Icons.check,
              size: 13,
              color: feature.isHighlighted ? Colors.black : Colors.white70,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              feature.text,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w300,
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}