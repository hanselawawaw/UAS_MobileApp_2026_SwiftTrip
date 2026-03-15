import 'package:flutter/material.dart';
import '../widgets/auth_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swifttrip_frontend/repositories/auth_repository.dart';
import 'verification.dart';

class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({super.key});

  @override
  State<ForgotPassPage> createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _verificationController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _verificationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 297,
                  child: Text(
                    'Forgot Password?\nWe Got You!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                    ),
                  ),
                ),
                const SizedBox(height: 50),

                // Email Field
                AuthWidgets.inputField(
                  controller: _emailController,
                  hint: 'Email',
                  obscure: false,
                ),
                const SizedBox(height: 14),

                // Email Verification Field (Row)
                AuthWidgets.verificationField(
                  controller: _verificationController,
                  hint: '6-digit Code',
                  onAskCode: () async {
                    final email = _emailController.text.trim();

                    if (email.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter your email first'),
                        ),
                      );
                      return;
                    }

                    try {
                      final authRepo = AuthRepository();
                      await authRepo.requestOtp(email, isPasswordReset: true);

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Verification code sent to your email!',
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              e.toString().replaceAll('Exception: ', ''),
                            ),
                          ),
                        );
                      }
                    }
                  },
                ),
                const SizedBox(height: 40),

                SizedBox(
                  width: 266,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Facebook
                      AuthWidgets.socialButton(
                        child: SvgPicture.asset(
                          'assets/icons/facebook_logo.svg',
                          width: 20,
                        ),
                      ),
                      // X (Twitter)
                      AuthWidgets.socialButton(
                        child: SvgPicture.asset(
                          'assets/icons/x_logo.svg',
                          width: 20,
                        ),
                      ),
                      // Google
                      AuthWidgets.socialButton(
                        child: SvgPicture.asset(
                          'assets/icons/google_logo.svg',
                          width: 20,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // Verify Button
                GestureDetector(
                  onTap: () async {
                    final email = _emailController.text;
                    final code = _verificationController.text;

                    if (email.isEmpty || code.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all fields')),
                      );
                      return;
                    }

                    try {
                      final authRepo = AuthRepository();
                      await authRepo.verifyOtp(email, code);

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Verification successful!'),
                          ),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerificationPage(email: email),
                          ),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              e.toString().replaceAll('Exception: ', ''),
                            ),
                          ),
                        );
                      }
                    }
                  },
                  child: Container(
                    width: 315,
                    height: 48,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF2B99E3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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
                    child: const Text(
                      'Continue',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFF7F9F9),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        height: 1.50,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
