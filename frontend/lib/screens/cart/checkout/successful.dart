import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/top_bar.dart';
import 'payment_detail.dart';
import '../customer_service/onboarding.dart';

class SuccessfulPage extends StatefulWidget {
  const SuccessfulPage({super.key});

  @override
  State<SuccessfulPage> createState() => _SuccessfulPageState();
}

class _SuccessfulPageState extends State<SuccessfulPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;

  static const String _checkSvg = '''
<svg width="124" height="124" viewBox="0 0 124 124" fill="none" xmlns="http://www.w3.org/2000/svg">
<g filter="url(#filter0_d_482_1238)">
<path fill-rule="evenodd" clip-rule="evenodd" d="M61.75 115.5C69.3338 115.5 76.8434 114.006 83.85 111.104C90.8565 108.202 97.2228 103.948 102.585 98.5854C107.948 93.2228 112.202 86.8565 115.104 79.85C118.006 72.8434 119.5 65.3338 119.5 57.75C119.5 50.1662 118.006 42.6566 115.104 35.65C112.202 28.6435 107.948 22.2772 102.585 16.9146C97.2228 11.552 90.8565 7.29817 83.85 4.39596C76.8434 1.49375 69.3338 -1.13008e-07 61.75 0C46.4337 2.2823e-07 31.7448 6.08436 20.9146 16.9146C10.0844 27.7448 4 42.4337 4 57.75C4 73.0663 10.0844 87.7552 20.9146 98.5854C31.7448 109.416 46.4337 115.5 61.75 115.5ZM60.2613 81.1067L92.3447 42.6067L82.4887 34.3933L54.897 67.4969L40.6199 53.2134L31.5468 62.2866L50.7967 81.5366L55.7633 86.5031L60.2613 81.1067Z" fill="#02C518"/>
</g>
<defs>
<filter id="filter0_d_482_1238" x="0" y="0" width="123.5" height="123.5" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
<feFlood flood-opacity="0" result="BackgroundImageFix"/>
<feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>
<feOffset dy="4"/>
<feGaussianBlur stdDeviation="2"/>
<feComposite in2="hardAlpha" operator="out"/>
<feColorMatrix type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.25 0"/>
<feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_482_1238"/>
<feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow_482_1238" result="shape"/>
</filter>
</defs>
</svg>
''';

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const PaymentDetailPage(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Column(
          children: [
            TopBar(
              showBackButton: true,
              onHamburgerTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OnboardingPage()),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ScaleTransition(
                      scale: _scaleAnim,
                      child: SvgPicture.string(
                        _checkSvg,
                        width: 124,
                        height: 124,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FadeTransition(
                      opacity: _fadeAnim,
                      child: const Text(
                        'Payment Successful',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
