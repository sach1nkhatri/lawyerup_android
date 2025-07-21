import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

import '../../../../app/constant/api_endpoints.dart';
import '../../../../app/constant/hive_constants.dart';
import '../../../auth/data/models/user_hive_model.dart';
import '../wigets/schedule_builder.dart';

class LawyerEditListingPage extends StatefulWidget {
  final Map<String, dynamic> lawyer;

  const LawyerEditListingPage({Key? key, required this.lawyer}) : super(key: key);

  @override
  State<LawyerEditListingPage> createState() => _LawyerEditListingPageState();
}

class _LawyerEditListingPageState extends State<LawyerEditListingPage> {
  final _form = <String, dynamic>{};
  List<Map<String, String>> education = [];
  List<Map<String, String>> workExperience = [];
  Map<String, List<Map<String, String>>> schedule = {};

  @override
  void initState() {
    super.initState();
    final data = widget.lawyer;

    _form.addAll({
      'specialization': data['specialization'] ?? '',
      'phone': data['phone'] ?? '',
      'state': data['state'] ?? '',
      'city': data['city'] ?? '',
      'address': data['address'] ?? '',
      'qualification': data['qualification'] ?? '',
      'description': data['description'] ?? '',
      'specialCase': data['specialCase'] ?? '',
      'socialLink': data['socialLink'] ?? '',
    });

    education = List<Map<String, String>>.from((data['education'] ?? []).map((e) => Map<String, String>.from(e)));
    workExperience = List<Map<String, String>>.from((data['workExperience'] ?? []).map((w) => Map<String, String>.from(w)));
    schedule = Map<String, List<Map<String, String>>>.from(
      (data['schedule'] ?? {}).map((day, slots) => MapEntry(
        day,
        List<Map<String, String>>.from(slots.map((s) => Map<String, String>.from(s))),
      )),
    );
  }

  void updateField(String key, String value) {
    setState(() {
      _form[key] = value;
    });
  }

  Future<void> saveChanges() async {
    final box = Hive.box<UserHiveModel>(HiveConstants.userBox);
    final token = box.get(HiveConstants.userKey)?.token;

    if (token == null) return;

    final uri = Uri.parse('${ApiEndpoints.baseUrl}/lawyers/${widget.lawyer['_id']}');
    final req = http.MultipartRequest('PUT', uri);
    req.headers['Authorization'] = 'Bearer $token';

    _form.forEach((k, v) => req.fields[k] = v ?? '');
    req.fields['education'] = jsonEncode(education);
    req.fields['workExperience'] = jsonEncode(workExperience);
    req.fields['schedule'] = jsonEncode(schedule);

    final res = await req.send();
    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated.')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update.')));
    }
  }

  Future<void> deleteListing() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Delete Listing?"),
        content: Text("This action is permanent."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text("Cancel")),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: Text("Delete")),
        ],
      ),
    );

    if (confirm != true) return;

    final token = Hive.box<UserHiveModel>(HiveConstants.userBox).get(HiveConstants.userKey)?.token;
    final res = await http.delete(
      Uri.parse('${ApiEndpoints.baseUrl}/lawyers/${widget.lawyer['_id']}'),
      headers: { 'Authorization': 'Bearer $token' },
    );

    if (res.statusCode == 200) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Listing deleted')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Delete failed')));
    }
  }

  Future<void> putOnHold() async {
    final token = Hive.box<UserHiveModel>(HiveConstants.userBox).get(HiveConstants.userKey)?.token;
    final res = await http.patch(
      Uri.parse('${ApiEndpoints.baseUrl}/lawyers/${widget.lawyer['_id']}/status'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'status': 'hold'}),
    );

    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile put on hold')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to hold')));
    }
  }

  Widget textInput(String key, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        initialValue: _form[key],
        onChanged: (val) => updateField(key, val),
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Listing")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            textInput('specialization', 'Specialization'),
            textInput('phone', 'Phone'),
            textInput('state', 'State'),
            textInput('city', 'City'),
            textInput('address', 'Address'),
            textInput('qualification', 'Qualification'),
            textInput('socialLink', 'Social Link'),
            textInput('specialCase', 'Special Case'),
            textInput('description', 'Description'),

            const SizedBox(height: 16),
            ScheduleBuilder(onScheduleChange: (data) => schedule = data, initialSchedule: schedule),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(child: ElevatedButton(onPressed: saveChanges, child: Text("Save"))),
                const SizedBox(width: 12),
                Expanded(child: ElevatedButton(onPressed: putOnHold, child: Text("Hold"))),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: deleteListing,
              child: const Text("Delete", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}
