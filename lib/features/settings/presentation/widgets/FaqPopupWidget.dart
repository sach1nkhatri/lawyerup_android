import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../../../../app/constant/api_endpoints.dart';

class FaqPopupWidget extends StatefulWidget {
  const FaqPopupWidget({super.key});

  @override
  State<FaqPopupWidget> createState() => _FaqPopupWidgetState();
}

class _FaqPopupWidgetState extends State<FaqPopupWidget> {
  bool isLoading = true;
  List<Map<String, dynamic>> faqs = [];
  String? error;

  @override
  void initState() {
    super.initState();
    fetchFaqs();
  }

  Future<void> fetchFaqs() async {
    try {
      final response = await Dio().get(ApiEndpoints.getFaqs);
      setState(() {
        faqs = List<Map<String, dynamic>>.from(response.data);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = "Failed to load FAQs";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.6,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Help & FAQ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : error != null
                    ? Center(child: Text(error!))
                    : ListView.separated(
                  itemCount: faqs.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final faq = faqs[index];
                    return ExpansionTile(
                      title: Text(faq['question'] ?? '',
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                          child: Text(faq['answer'] ?? ''),
                        )
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Close"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
