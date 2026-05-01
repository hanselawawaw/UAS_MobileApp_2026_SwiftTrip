import 'package:flutter/material.dart';
import '../../models/subscription_plan_model.dart';
import 'feature_row.dart';

class PlanCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final bool isActive;
  final VoidCallback? onUpgrade;

  const PlanCard({
    super.key,
    required this.plan,
    required this.isActive,
    this.onUpgrade,
  });

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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: plan.features
                      .map(
                        (f) => FeatureRow(
                          feature: f,
                          accentColor: plan.gradientColor,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),

          // ── Confirm Button (Gradient) ────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: GestureDetector(
              onTap: () {
                if (!plan.isCurrent && onUpgrade != null) {
                  onUpgrade!();
                }
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
