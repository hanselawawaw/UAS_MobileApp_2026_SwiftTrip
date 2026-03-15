import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'forgot_pass/forgot_pass.dart';
import 'package:swifttrip_frontend/repositories/auth_repository.dart';
import 'widgets/auth_widgets.dart';
import 'user_info.dart';

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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter your email first'),
                        ),
                      );
                      return;
                    }

                    try {
                      final authRepo = AuthRepository();
                      await authRepo.requestOtp(email);

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
                SizedBox(
                  width: 266,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Facebook Pill
                      AuthWidgets.socialButton(
                        child: SvgPicture.asset(
                          'assets/icons/facebook_logo.svg',
                          width: 20,
                        ),
                      ),
                      // X (Twitter) Pill
                      AuthWidgets.socialButton(
                        child: SvgPicture.asset(
                          'assets/icons/x_logo.svg',
                          width: 20,
                        ),
                      ),
                      // Google Pill
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

                // ── Primary Action: Sign Up Button ────────────────────
                GestureDetector(
                  onTap: () async {
                    final email = _emailController.text.trim();
                    final password = _passwordController.text;
                    final confirm = _confirmPasswordController.text;
                    final otp = _verificationController.text.trim();

                    if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all fields')),
                      );
                      return;
                    }
                    if (password != confirm) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Passwords do not match')),
                      );
                      return;
                    }

                    try {
                      final authRepo = AuthRepository();
                      await authRepo.verifyOtp(email, otp);

                      bool signupSuccess = await authRepo.signup(
                        email,
                        password,
                        confirm,
                      );
                      if (signupSuccess && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Signup successful! Please complete your profile.'),
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
                  child: Container(
                    width: 315,
                    height: 48,
                    decoration: ShapeDecoration(
                      // Main blue theme color
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
                      'Sign Up',
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
                const SizedBox(height: 20),

                // ── Footer: Already Have An Account? ─────────────────
                SizedBox(
                  width: 315,
                  height: 48,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Already Have an account?',
                        style: TextStyle(
                          color: Color(0xFF0C161C),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          height: 1.50,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          // Navigate back to login screen
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Color(0xFF2B99E3),
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            height: 1.50,
                          ),
                        ),
                      ),
                    ],
                  ),
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
