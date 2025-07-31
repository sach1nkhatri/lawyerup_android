import 'package:flutter/material.dart';

class PrivacyPopup extends StatelessWidget {
  const PrivacyPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxHeight: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Privacy & Disclaimers",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 24),

            // Scrollable disclaimer content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(" Chatbot Usage", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text(
                      "The AI chatbot provides information for legal education and general reference only. It is not a replacement for professional legal advice. Always consult with a qualified lawyer for any legal concerns.",
                    ),

                    SizedBox(height: 16),
                    Text(" Booking Responsibility", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text(
                      "Appointments are handled independently by users and lawyers. LawyerUp is not responsible for any missed, canceled, or fraudulent bookings.",
                    ),

                    SizedBox(height: 16),
                    Text(" Respect & Community Guidelines", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text(
                      "All users are expected to behave respectfully. Any abusive, discriminatory, or unethical behavior may lead to account suspension.",
                    ),

                    SizedBox(height: 16),
                    Text(" General Disclaimer", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text(
                      "We do not guarantee accuracy, reliability, or legal validity of any content generated or listed in the app. Use at your own discretion.",
                    ),

                    SizedBox(height: 16),
                    Text(" Data Privacy", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text(
                      "Your data is stored securely and only used for essential app functionality. We do not sell your information. Always ensure your device is protected.",
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Close Button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
