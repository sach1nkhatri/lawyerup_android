import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const tealFieldColor = Color(0xFFB5F7ED);
    const accentTeal = Color(0xFF18EFCB);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background image
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

          // Content
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),

                  // Hammer icon
                  Center(
                    child: Image.asset(
                      'assets/images/hammer.png',
                      width: 70,
                      height: 70,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Title
                  const Center(
                    child: Text(
                      'SignUp New Account',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Email
                  _buildRoundedTextField('Username or Email', tealFieldColor),

                  const SizedBox(height: 16),

                  // Name
                  _buildRoundedTextField('Name', tealFieldColor),

                  const SizedBox(height: 16),

                  // Phone
                  _buildRoundedTextField('Phone number', tealFieldColor),

                  const SizedBox(height: 16),

                  // Password
                  _buildRoundedTextField('Password', tealFieldColor, obscure: true),

                  const SizedBox(height: 16),

                  // Confirm Password with arrow
                  Container(
                    decoration: BoxDecoration(
                      color: tealFieldColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Confirm Password',
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 50,
                          margin: const EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                            color: accentTeal,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_forward, size: 20),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Already have account
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          "Already have an account",
                          style: TextStyle(color: Colors.black54),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context); // ⬅️ Go back to LoginPage
                          },
                          child: const Text(
                            "Login?",
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

                  const Spacer(),

                  // Google Button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Google sign in logic
                        },
                        icon: const Icon(Icons.g_mobiledata, size: 28), // Placeholder
                        label: const Text('Sign in with Google'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
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

  // Reusable input field
  Widget _buildRoundedTextField(String hint, Color color,
      {bool obscure = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        obscureText: obscure,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
        ),
      ),
    );
  }
}
