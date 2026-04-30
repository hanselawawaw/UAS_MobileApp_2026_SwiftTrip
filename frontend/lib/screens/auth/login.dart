import 'package:flutter/material.dart';
import 'package:swifttrip_frontend/screens/main/main_screen.dart';
import 'signup.dart';
import 'forgot_pass/forgot_pass.dart';
import 'widgets/auth_widgets.dart';
import 'widgets/auth_primary_button.dart';
import 'widgets/social_auth_group.dart';
import 'widgets/auth_footer_link.dart';
import 'models/auth_models.dart';
import 'services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── Title ──────────────────────────────────────────────
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
                const SizedBox(height: 30),

                // ── Email Field ────────────────────────────────────────
                AuthWidgets.inputField(
                  controller: _emailController,
                  hint: 'Email',
                  obscure: false,
                ),
                const SizedBox(height: 14),

                // ── Password Field ─────────────────────────────────────
                AuthWidgets.inputField(
                  controller: _passwordController,
                  hint: 'Password',
                  obscure: _obscurePassword,
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
                const SizedBox(height: 25),

                // ── Social Buttons: Facebook · X · Google ──────────────
                const SocialAuthGroup(),
                const SizedBox(height: 25),

                // ── Log In Button ──────────────────────────────────────
                _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2B99E3)),
                      )
                    : AuthPrimaryButton(
                        text: 'Log in',
                        onTap: () async {
                          final email = _emailController.text;
                          final password = _passwordController.text;
                          if (email.isEmpty || password.isEmpty) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please fill all fields')),
                            );
                            return;
                          }

                          setState(() => _isLoading = true);

                          try {
                            final success = await _authService.login(
                              LoginRequest(email: email, password: password),
                            );

                            if (success && mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MainScreen(),
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
                          } finally {
                            if (mounted) {
                              setState(() => _isLoading = false);
                            }
                          }
                        },
                      ),
                const SizedBox(height: 12),

                // ── New user? Sign Up ──────────────────────────────────
                AuthFooterLink(
                  label: 'New user?',
                  linkText: 'Sign Up',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),

                // ── Forgot Password ────────────────────────────────────
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
