// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'forgot_pass/forgot_pass.dart';
import 'widgets/auth_widgets.dart';
import 'widgets/auth_primary_button.dart';
import 'widgets/social_auth_group.dart';
import 'widgets/auth_footer_link.dart';
import 'user_info.dart';
import 'models/auth_models.dart';
import 'services/auth_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // TextEditingControllers for all input fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _verificationController = TextEditingController();

  final AuthService _authService = AuthService();

  // State variable to manage password visibility toggles
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    // Crucial: always dispose of controllers when no longer needed
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _verificationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Replicating the clean background color from login.dart
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            // Matching centered layout
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── Title: Replicated Exactly ─────────────────────────
                const SizedBox(
                  width: 297,
                  child: Text(
                    'Plan your vacation\nin a flash.',
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

                // ── Input Fields ──────────────────────────────────────
                // Email Field
                AuthWidgets.inputField(
                  controller: _emailController,
                  hint: 'Email',
                  obscure: false,
                ),
                const SizedBox(height: 14),

                // Password Field
                AuthWidgets.inputField(
                  controller: _passwordController,
                  hint: 'Password',
                  obscure: _obscurePassword,
                  // Toggled suffix icon
                  suffixIcon: GestureDetector(
                    onTap: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    child: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.remove_red_eye,
                      color: const Color(0xFF4F7A93),
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Confirm Password Field
                AuthWidgets.inputField(
                  controller: _confirmPasswordController,
                  hint: 'Confirm Password',
                  obscure: _obscureConfirmPassword,
                  // Toggled suffix icon
                  suffixIcon: GestureDetector(
                    onTap: () => setState(
                      () => _obscureConfirmPassword = !_obscureConfirmPassword,
                    ),
                    child: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.remove_red_eye,
                      color: const Color(0xFF4F7A93),
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Email Verification Field (Row)
                AuthWidgets.verificationField(
                  controller: _verificationController,
                  hint: 'Email Verification',
                  onAskCode: () async {
                    final email = _emailController.text.trim();

                    if (email.isEmpty) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter your email first'),
                        ),
                      );
                      return;
                    }

                    try {
                      await _authService.requestOtp(email);

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
                const SizedBox(height: 25),

                // ── Social Buttons: Replicated Style ──────────────────
                const SocialAuthGroup(),
                const SizedBox(height: 25),

                // ── Primary Action: Sign Up Button ────────────────────
                AuthPrimaryButton(
                  text: 'Sign Up',
                  onTap: () async {
                    final email = _emailController.text.trim();
                    final password = _passwordController.text;
                    final confirm = _confirmPasswordController.text;
                    final otp = _verificationController.text.trim();

                    if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all fields')),
                      );
                      return;
                    }
                    if (password != confirm) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Passwords do not match')),
                      );
                      return;
                    }

                    try {
                      await _authService.verifyOtp(email, otp);

                      bool signupSuccess = await _authService.signup(
                        SignupRequest(
                          email: email,
                          password: password,
                          confirmPassword: confirm,
                        ),
                      );
                      if (signupSuccess && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Signup successful! Please complete your profile.',
                            ),
                          ),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserInfoPage(),
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
                const SizedBox(height: 20),

                // ── Footer: Already Have An Account? ─────────────────
                AuthFooterLink(
                  label: 'Already Have an account?',
                  linkText: 'Login',
                  onTap: () {
                    // Navigate back to login screen
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 12),

                // ── Tertiary Link: Forgot Password ───────────────────
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPassPage(),
                      ),
                    );
                  },
                  child: Container(
                    width: 367,
                    padding: const EdgeInsets.only(
                      top: 4,
                      left: 16,
                      right: 16,
                      bottom: 12,
                    ),
                    child: const Text(
                      'Forgot password?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF4F7A93),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
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
