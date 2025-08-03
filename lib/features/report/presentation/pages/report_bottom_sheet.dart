import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../app/constant/api_endpoints.dart';
import '../../../../app/constant/hive_constants.dart';
import '../../../auth/data/models/user_hive_model.dart';

class ReportBottomSheet extends StatefulWidget {
  final VoidCallback onClose;

  const ReportBottomSheet({super.key, required this.onClose});

  @override
  State<ReportBottomSheet> createState() => _ReportBottomSheetState();
}

class _ReportBottomSheetState extends State<ReportBottomSheet> {
  String? selectedIssue;
  String customIssue = '';
  bool submitting = false;

  final List<String> issueOptions = [
    'Incorrect legal information',
    'Chatbot not responding',
    'Broken link or page',
    'Appointment issue',
    'Other',
  ];

  Future<void> handleSubmit() async {
    final issue = selectedIssue == 'Other' ? customIssue.trim() : selectedIssue;

    if (issue == null || issue.isEmpty) {
      _showSnack('Please select or describe an issue');
      return;
    }

    try {
      setState(() => submitting = true);

      final box = Hive.box<UserHiveModel>(HiveConstants.userBox);
      final user = box.get(HiveConstants.userKey);

      if (user == null || user.uid.isEmpty) {
        _showSnack('User not found. Please log in again.', isError: true);
        return;
      }

      print('📤 Sending report: UID=${user.uid}, issue="$issue"');

      final response = await http.post(
        Uri.parse(ApiEndpoints.report),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user': user.uid, 'message': issue}),
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      final resBody = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSnack(resBody['message'] ?? 'Report submitted!');
        widget.onClose();
      } else {
        throw Exception(resBody['error'] ?? 'Something went wrong.');
      }
    } catch (e) {
      print('❌ Report submit failed: $e');
      _showSnack('Failed to submit report: $e', isError: true);
    } finally {
      setState(() => submitting = false);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    final color = isError ? Colors.red : Colors.green;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context); // for keyboard handling

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: mediaQuery
              .viewInsets
              .bottom, // ensures keyboard pushes content up
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Report an Issue',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                ...issueOptions.map((issue) {
                  return RadioListTile<String>(
                    activeColor: Colors.deepPurple,
                    title: Text(
                      issue,
                      style: const TextStyle(color: Colors.white),
                    ),
                    value: issue,
                    groupValue: selectedIssue,
                    onChanged: (value) => setState(() => selectedIssue = value),
                  );
                }),
                if (selectedIssue == 'Other')
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Describe your issue...',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white10,
                    ),
                    maxLines: 3,
                    onChanged: (val) => customIssue = val,
                  ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: submitting ? null : widget.onClose,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: submitting ? null : handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                        ),
                        child: Text(submitting ? 'Submitting...' : 'Submit'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}