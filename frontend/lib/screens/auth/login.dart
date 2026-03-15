import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swifttrip_frontend/screens/home/home.dart';
import 'package:swifttrip_frontend/screens/main/main_screen.dart';
import 'signup.dart';
import 'forgot_pass/forgot_pass.dart';
import 'package:swifttrip_frontend/repositories/auth_repository.dart';
import 'widgets/auth_widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Vacation Planner',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

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

                // ── Log In Button ──────────────────────────────────────
                GestureDetector(
                  onTap: () async {
                    final email = _emailController.text;
                    final password = _passwordController.text;
                    if (email.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all fields')),
                      );
                      return;
                    }

                    try {
                      final authRepo = AuthRepository();
                      bool success = await authRepo.login(email, password);

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
                      'Log in',
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
                const SizedBox(height: 12),

                // ── New user? Sign Up ──────────────────────────────────
                SizedBox(
                  width: 315,
                  height: 48,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'New user?',
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Sign Up',
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
