// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../widgets/auth_widgets.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/social_auth_group.dart';
import 'verification.dart';
import '../services/auth_service.dart';

class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({super.key});

  @override
  State<ForgotPassPage> createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _verificationController = TextEditingController();
  final AuthService _authService = AuthService();

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
                      await _authService.requestOtp(
                        email,
                        isPasswordReset: true,
                      );

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

                const SocialAuthGroup(),

                const SizedBox(height: 25),

                // Verify Button
                AuthPrimaryButton(
                  text: 'Continue',
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
                      await _authService.verifyOtp(email, code);

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Verification successful!'),
                          ),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                VerificationPage(email: email),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
