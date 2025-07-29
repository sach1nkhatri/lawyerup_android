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
  String selectedMethod = 'esewa';
  File? screenshotFile;
  bool isSubmitting = false;

  final paymentMethods = {
    'esewa': 'eSewa',
    'khalti': 'Khalti',
    'ime': 'IME Pay',
    'bank': 'Bank Transfer',
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

      final token = HiveService.getUser()?.token;
      final userId = HiveService.getUser()?.uid;
      if (token == null || userId == null) throw Exception("Unauthorized");

      final formData = FormData.fromMap({
        'user': userId,
        'plan': widget.planName,
        'price': widget.planPrice,
        'duration': widget.planDuration,
        'method': selectedMethod,
        'screenshot': await MultipartFile.fromFile(screenshotFile!.path, filename: 'payment.jpg'),
      });

      await Dio().post(
        ApiEndpoints.manualPayment,
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      GlobalSnackBar.show(context, "Payment submitted for review.", type: SnackType.success);
      Navigator.pop(context);

    } catch (e) {
      GlobalSnackBar.show(context, "Failed to submit payment.", type: SnackType.error);
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  Widget buildQRImage() {
    String asset = {
      'esewa': 'assets/qr/esewa-qr.png',
      'khalti': 'assets/qr/khalti-qr.png',
      'ime': 'assets/qr/imepay-qr.png',
      'bank': 'assets/qr/bank-qr.png',
    }[selectedMethod]!;

    return Image.asset(asset, height: 160);
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
