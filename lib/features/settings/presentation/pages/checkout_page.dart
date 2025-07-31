import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../../app/constant/api_endpoints.dart';
import '../../../../app/shared/services/hive_service.dart';
import '../../../../app/shared/widgets/global_snackbar.dart';

class CheckoutPage extends StatefulWidget {
  final String planName;
  final String planPrice;
  final String planDuration;

  const CheckoutPage({
    super.key,
    required this.planName,
    required this.planPrice,
    required this.planDuration,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String selectedMethod = 'eSewa';
  File? screenshotFile;
  bool isSubmitting = false;

  final paymentMethods = {
    'eSewa': 'eSewa',
    'Khalti': 'Khalti',
    'IME': 'IME Pay',
    'Bank': 'Bank Transfer',
  };

  Future<void> pickScreenshot() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        screenshotFile = File(result.files.first.path!);
      });
    }
  }

  Future<void> submitPayment() async {
    if (screenshotFile == null) {
      GlobalSnackBar.show(context, "Please upload a screenshot.", type: SnackType.error);
      return;
    }

    try {
      setState(() => isSubmitting = true);

      final user = HiveService.getUser();
      if (user == null) throw Exception("User not found");

      // Extract numeric value from price string
      final rawAmount = widget.planPrice.replaceAll(RegExp(r'[^0-9.]'), '');
      final amount = double.tryParse(rawAmount);
      if (amount == null) throw Exception("Invalid amount format");

      final now = DateTime.now();
      final duration = widget.planDuration.toLowerCase();
      late DateTime validUntil;

      if (duration.contains("day")) {
        validUntil = now.add(const Duration(days: 1));
      } else if (duration.contains("week")) {
        validUntil = now.add(const Duration(days: 7));
      } else {
        validUntil = now.add(const Duration(days: 30));
      }

      final formData = FormData.fromMap({
        'plan': widget.planName,
        'amount': amount,
        'method': selectedMethod,
        'duration': widget.planDuration,
        'validUntil': validUntil.toIso8601String(),
        'screenshot': await MultipartFile.fromFile(
          screenshotFile!.path,
          filename: screenshotFile!.path.split('/').last,
        ),
      });

      final response = await Dio().post(
        ApiEndpoints.manualPayment,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${user.token}',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        GlobalSnackBar.show(context, "Payment submitted for review.", type: SnackType.success);
        Navigator.pop(context);
      } else {
        GlobalSnackBar.show(context, "Server error: ${response.statusMessage}", type: SnackType.error);
      }
    } catch (e) {
      debugPrint("Payment Error: $e");
      GlobalSnackBar.show(context, "Failed to submit payment.", type: SnackType.error);
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  Widget buildQRImage() {
    String asset = {
      'eSewa': 'assets/payment_codes/esewa-code.JPG',
      'Khalti': 'assets/payment_codes/khalti-code.PNG',
      'IME': 'assets/payment_codes/imepay-code.JPG',
      'Bank': 'assets/payment_codes/bank-code.PNG',
    }[selectedMethod]!;

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => Dialog(
            backgroundColor: Colors.transparent,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: InteractiveViewer(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(asset),
                ),
              ),
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(asset, height: 160),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout", style: TextStyle(fontFamily: 'Lora')),
        backgroundColor: const Color(0xFF1E2B3A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              widget.planName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Lora'),
            ),
            const SizedBox(height: 6),
            Text(widget.planPrice, style: const TextStyle(fontSize: 16, fontFamily: 'PlayfairDisplay')),
            Text(widget.planDuration, style: const TextStyle(fontSize: 14, fontFamily: 'PlayfairDisplay')),
            const Divider(height: 32),

            const Text("Select Payment Method", style: TextStyle(fontFamily: 'PlayfairDisplay')),
            const SizedBox(height: 12),

            Wrap(
              spacing: 10,
              children: paymentMethods.entries.map((entry) {
                final isSelected = selectedMethod == entry.key;
                return ChoiceChip(
                  label: Text(entry.value),
                  selected: isSelected,
                  onSelected: (_) => setState(() => selectedMethod = entry.key),
                  selectedColor: Colors.deepPurple,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontFamily: 'PlayfairDisplay',
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),
            buildQRImage(),
            const SizedBox(height: 20),

            Row(
              children: [
                const Icon(Icons.upload_file, size: 20),
                const SizedBox(width: 6),
                const Text("Upload Screenshot", style: TextStyle(fontFamily: 'PlayfairDisplay')),
                const Spacer(),
                ElevatedButton(
                  onPressed: pickScreenshot,
                  child: const Text("Browse", style: TextStyle(fontFamily: 'PlayfairDisplay')),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (screenshotFile != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(screenshotFile!, height: 180),
              ),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isSubmitting ? null : submitPayment,
                icon: isSubmitting
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
                    : const Icon(Icons.check_circle),
                label: Text(
                  isSubmitting ? "Submitting..." : "I’ve Paid – Submit for Review",
                  style: const TextStyle(fontFamily: 'PlayfairDisplay'),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
