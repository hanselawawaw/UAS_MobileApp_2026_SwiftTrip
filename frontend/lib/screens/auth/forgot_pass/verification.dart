// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../widgets/auth_widgets.dart';
import '../widgets/auth_primary_button.dart';
import '../services/auth_service.dart';

class VerificationPage extends StatefulWidget {
  final String email;
  const VerificationPage({super.key, required this.email});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                const SizedBox(
                  width: 297,
                  child: Text(
                    'One More Step and\nYou’re Ready',
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
                AuthWidgets.inputField(
                  controller: _passwordController,
                  hint: 'Password',
                  obscure: true,
                ),
                const SizedBox(height: 14),
                AuthWidgets.inputField(
                  controller: _confirmPasswordController,
                  hint: 'Confirm Password',
                  obscure: true,
                ),
                const SizedBox(height: 50),
                AuthPrimaryButton(
                  text: 'Confirm',
                  onTap: () async {
                    final password = _passwordController.text;
                    final confirmPassword = _confirmPasswordController.text;

                    if (password.isEmpty || confirmPassword.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all fields')),
                      );
                      return;
                    }

                    if (password != confirmPassword) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Passwords do not match')),
                      );
                      return;
                    }

                    try {
                      await _authService.updatePassword(widget.email, password);

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Password updated successfully!'),
                          ),
                        );
                        // Navigate back to login
                        Navigator.popUntil(context, (route) => route.isFirst);
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
