import 'package:flutter/material.dart';
import '../widgets/plan_card.dart';
import '../widgets/plan_toggle_tabs.dart';
import 'checkout_page.dart';

class PricingPage extends StatefulWidget {
  const PricingPage({super.key});

  @override
  State<PricingPage> createState() => _PricingPageState();
}

class _PricingPageState extends State<PricingPage> {
  String selectedDuration = 'daily';

  final pricing = {
    'daily': {'basic': 'NPR.50/day', 'premium': 'NPR.100/day'},
    'weekly': {'basic': 'NPR.180/week', 'premium': 'NPR.400/week'},
    'monthly': {'basic': 'NPR.300/month', 'premium': 'NPR.600/month'},
  };

  final featuresBasic = [
    'Unlimited AI Chat Access',
    'News & Legal Articles',
    'Lawyer Booking',
    'Perfect for Students & Citizens',
  ];

  final featuresPremium = [
    'Everything in Basic Plan',
    'Advanced Legal Reasoning',
    'PDF Analyzer Tools',
    '24/7 Tech Support',
    'Great for Lawyers & Firms',
  ];

  String getDurationLabel() {
    return selectedDuration[0].toUpperCase() + selectedDuration.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Your Plan", style: TextStyle(fontFamily: 'Lora')),
        backgroundColor: const Color(0xFF1E2B3A),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PlanToggleTabs(
              activeTab: selectedDuration,
              onTabChange: (newTab) {
                setState(() => selectedDuration = newTab);
              },
            ),
            const SizedBox(height: 20),
            PlanCard(
              planName: 'Basic Plan',
              planPrice: pricing[selectedDuration]!['basic']!,
              durationLabel: getDurationLabel(),
              features: featuresBasic,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CheckoutPage(
                      planName: 'Basic Plan',
                      planPrice: pricing[selectedDuration]!['basic']!,
                      planDuration: getDurationLabel(),
                    ),
                  ),
                );
              },
            ),
            PlanCard(
              planName: 'Premium Plan',
              planPrice: pricing[selectedDuration]!['premium']!,
              durationLabel: getDurationLabel(),
              features: featuresPremium,
              isPopular: selectedDuration == 'monthly',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CheckoutPage(
                      planName: 'Premium Plan',
                      planPrice: pricing[selectedDuration]!['premium']!,
                      planDuration: getDurationLabel(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
