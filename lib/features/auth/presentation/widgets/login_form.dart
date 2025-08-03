import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLogin;
  final bool isLoading;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onLogin,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    const tealFieldColor = Color(0xFFB5F7ED);
    const accentTeal = Color(0xFF18EFCB);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            top: 10,
            left: -7,
            right: -7,
            bottom: -8,
            child: Image.asset(
              'assets/images/Authentication.png',
              fit: BoxFit.fill,
              filterQuality: FilterQuality.high,
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/hammer.png', width: 70),
                        const SizedBox(height: 24),
                        const Text(
                          'Signin to your Account',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 30),

                        /// EMAIL FIELD WITH KEY
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: tealFieldColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextField(
                            key: const Key('emailField'),
                            controller: emailController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Username or Email',
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        /// PASSWORD FIELD WITH KEY
                        Container(
                          decoration: BoxDecoration(
                            color: tealFieldColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: TextField(
                                    key: const Key('passwordField'),
                                    controller: passwordController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Enter your password',
                                    ),
                                  ),
                                ),
                              ),

                              /// LOGIN BUTTON
                              Container(
                                height: 50,
                                width: 50,
                                margin: const EdgeInsets.only(right: 2),
                                decoration: const BoxDecoration(
                                  color: accentTeal,
                                  shape: BoxShape.circle,
                                ),
                                child: InkWell(
                                  key: const Key('loginButton'),
                                  onTap: isLoading ? null : onLogin,
                                  child: isLoading
                                      ? const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                      : const Icon(Icons.arrow_forward, size: 20),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                        const Text("Don't have an account", style: TextStyle(color: Colors.black54)),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/signup'),
                          child: const Text(
                            "SignUp?",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
