import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final String _appName = "Swift Trip";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _controller.forward();

    // Future navigation logic can be placed here
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
      }
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
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [_buildLogoAnimation(), _buildTextAnimation()],
        ),
      ),
    );
  }

  Widget _buildLogoAnimation() {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Transform.translate(
        offset: const Offset(0, 0),
        child: FadeTransition(
          opacity: CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
          ),
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _controller,
              curve: const Interval(0.7, 1.0, curve: Curves.easeOutBack),
            ),
            child: SizedBox(
              width: 31,
              height: 21,
              child: SvgPicture.string(
                '''<svg width="31" height="21" viewBox="0 0 31 21" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M30 2.00088C30.2652 2.01209 30.5196 1.91655 30.7071 1.72882C30.8946 1.54148 31 1.2773 31 1.00088C31 0.724463 30.8946 0.460293 30.7071 0.272944C30.5196 0.0852201 30.2652 -0.0103202 30 0.000884056C29.6 0.0175507 29.2 0.0342174 28.8 0.0508841C21.6 0.350884 14.4 0.650884 7.2 0.950884C6.8 0.967551 6.4 0.984217 6 1.00088C6.4 1.01755 6.8 1.03422 7.2 1.05088C14.4 1.35088 21.6 1.65088 28.8 1.95088C29.2 1.96755 29.6 1.98422 30 2.00088Z" fill="black"/>
<path d="M27 11.5009C27.2652 11.5121 27.5196 11.4165 27.7071 11.2288C27.8946 11.0415 28 10.7773 28 10.5009C28 10.2245 27.8946 9.96029 27.7071 9.77294C27.5196 9.58522 27.2652 9.48968 27 9.50088C26.6 9.51755 26.2 9.53422 25.8 9.55088C18.6 9.85088 11.4 10.1509 4.2 10.4509C3.8 10.4676 3.4 10.4842 3 10.5009C3.4 10.5176 3.8 10.5342 4.2 10.5509C11.4 10.8509 18.6 11.1509 25.8 11.4509C26.2 11.4676 26.6 11.4842 27 11.5009Z" fill="black"/>
<path d="M24 21.0009C24.2652 21.0121 24.5196 20.9165 24.7071 20.7288C24.8946 20.5415 25 20.2773 25 20.0009C25 19.7245 24.8946 19.4603 24.7071 19.2729C24.5196 19.0852 24.2652 18.9897 24 19.0009C23.6 19.0176 23.2 19.0342 22.8 19.0509C15.6 19.3509 8.4 19.6509 1.2 19.9509C0.799998 19.9676 0.4 19.9842 0 20.0009C0.4 20.0176 0.799998 20.0342 1.2 20.0509C8.4 20.3509 15.6 20.6509 22.8 20.9509C23.2 20.9676 23.6 20.9842 24 21.0009Z" fill="black"/>
</svg>
''',
                colorFilter: const ColorFilter.mode(
                  Colors.black,
                  BlendMode.srcIn,
                ),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextAnimation() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(_appName.length, (index) {
        int reverseIndex = _appName.length - 1 - index;
        double start = reverseIndex * 0.06;
        double end = start + 0.3;

        Animation<double> slideAnim = Tween<double>(begin: -100.0, end: 0.0)
            .animate(
              CurvedAnimation(
                parent: _controller,
                curve: Interval(start, end, curve: Curves.easeOutCubic),
              ),
            );

        Animation<double> fadeAnim = Tween<double>(begin: 0.0, end: 1.0)
            .animate(
              CurvedAnimation(
                parent: _controller,
                curve: Interval(start, end, curve: Curves.easeIn),
              ),
            );

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(slideAnim.value, 0),
              child: Opacity(
                opacity: fadeAnim.value,
                child: Text(
                  _appName[index],
                  style: GoogleFonts.cardo(
                    color: Colors.black,
                    fontSize: 25,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
