import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../app/constant/hive_constants.dart';
import '../../../../app/constant/api_endpoints.dart';
import '../../../auth/data/models/user_hive_model.dart';
import '../wigets/schedule_builder.dart';
import 'lawyer_status_page.dart';

class JoinAsLawyerPage extends StatefulWidget {
  const JoinAsLawyerPage({Key? key}) : super(key: key);

  @override
  State<JoinAsLawyerPage> createState() => _JoinAsLawyerPageState();
}

class _JoinAsLawyerPageState extends State<JoinAsLawyerPage> {
  int step = 1;
  bool isJunior = false;
  File? profileImage;
  File? licenseFile;

  final form = <String, String>{
    'fullName': '', 'specialization': '', 'email': '', 'phone': '',
    'state': '', 'city': '', 'address': '', 'expectedGraduation': '',
    'description': '', 'specialCase': '', 'socialLink': '',
    'eduDegree': '', 'eduInstitute': '', 'eduYear': '', 'eduSpecialization': '',
    'workCourt': '', 'workFrom': '', 'workTo': '',
  };

  List<Map<String, String>> educationList = [];
  List<Map<String, String>> workList = [];
  Map<String, List<Map<String, String>>> schedule = {};

  @override
  void initState() {
    super.initState();
    _checkIfAlreadyLawyer();
  }

  Future<void> _checkIfAlreadyLawyer() async {
    final box = Hive.box<UserHiveModel>(HiveConstants.userBox);
    final user = box.get(HiveConstants.userKey);
    final token = user?.token;

    if (token == null) return;

    final res = await http.get(
      Uri.parse(ApiEndpoints.getLawyerByUser), // MUST point to /lawyers/me
      headers: { 'Authorization': 'Bearer $token' },
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data['status'] != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LawyerStatusPage(lawyer: data)),
        );
      }
    }
  }


  void addEducation() {
    setState(() {
      educationList.add({
        'degree': form['eduDegree']!,
        'institute': form['eduInstitute']!,
        'year': form['eduYear']!,
        'specialization': form['eduSpecialization']!,
      });
      form['eduDegree'] = '';
      form['eduInstitute'] = '';
      form['eduYear'] = '';
      form['eduSpecialization'] = '';
    });
  }

  void addWork() {
    setState(() {
      workList.add({
        'court': form['workCourt']!,
        'from': form['workFrom']!,
        'to': form['workTo']!,
      });
      form['workCourt'] = '';
      form['workFrom'] = '';
      form['workTo'] = '';
    });
  }

  Widget input(String key, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: form[key],
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: (val) => form[key] = val,
      ),
    );
  }

  Widget fileUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Profile Photo & License", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: profileImage != null ? FileImage(profileImage!) : null,
              child: profileImage == null
                  ? const Icon(Icons.person, size: 30, color: Colors.black54)
                  : null,
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.image),
              label: const Text("Choose Image"),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1C2D3D)),
              onPressed: () async {
                final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
                if (picked != null) setState(() => profileImage = File(picked.path));
              },
            ),
          ],
        ),
        if (profileImage != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text("Selected: ${profileImage!.path.split('/').last}",
                style: const TextStyle(fontSize: 12)),
          ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          icon: const Icon(Icons.picture_as_pdf),
          label: const Text("Upload License PDF"),
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1C2D3D)),
          onPressed: () async {
            final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
            if (result != null) {
              setState(() => licenseFile = File(result.files.single.path!));
            }
          },
        ),
        if (licenseFile != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text("Selected: ${licenseFile!.path.split('/').last}",
                style: const TextStyle(fontSize: 12)),
          ),
      ],
    );
  }

  Future<void> submitForm() async {
    final user = Hive.box<UserHiveModel>(HiveConstants.userBox).get(HiveConstants.userKey);
    final token = user?.token;
    final uid = user?.uid;
    if (token == null || uid == null) return;

    final uri = Uri.parse(ApiEndpoints.createLawyer);
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['user'] = uid;
    request.fields['role'] = isJunior ? 'junior' : 'senior';
    form.forEach((key, value) => request.fields[key] = value);
    request.fields['education'] = jsonEncode(educationList);
    request.fields['workExperience'] = jsonEncode(workList);
    request.fields['schedule'] = jsonEncode(schedule);

    if (profileImage != null) {
      request.files.add(await http.MultipartFile.fromPath('profilePhoto', profileImage!.path));
    }
    if (licenseFile != null) {
      request.files.add(await http.MultipartFile.fromPath('licenseFile', licenseFile!.path));
    }

    final response = await request.send();
    final res = await http.Response.fromStream(response);
    if (res.statusCode == 201) {
      final data = jsonDecode(res.body);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LawyerStatusPage(lawyer: data)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Submission failed"))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C2D3D),
        title: const Text("Join as a Lawyer", style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(step == 1 ? "Personal Info" : "Education & Schedule",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          if (step == 1) ...[
            input('fullName', 'Full Name'),
            if (!isJunior) input('specialization', 'Specialization'),
            input('email', 'Email'),
            input('phone', 'Phone'),
            input('state', 'State'),
            input('city', 'City'),
            input('address', 'Address'),
            const SizedBox(height: 10),
            fileUploadSection(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => setState(() => step = 2),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1C2D3D)),
              child: const Text("Next"),
            ),
          ] else ...[
            if (isJunior) input('expectedGraduation', 'Expected Graduation Year'),
            input('description', 'Description'),
            input('specialCase', 'Special Case'),
            input('socialLink', 'Social Link'),
            const Divider(height: 30),
            input('eduDegree', 'Degree'),
            input('eduInstitute', 'Institute'),
            input('eduYear', 'Year'),
            input('eduSpecialization', 'Specialization'),
            ElevatedButton(onPressed: addEducation, child: const Text("Add Education")),
            ...educationList.map((e) => ListTile(
              leading: const Icon(Icons.school),
              title: Text("${e['degree']} at ${e['institute']} (${e['year']})"),
            )),
            if (!isJunior) ...[
              input('workCourt', 'Court'),
              input('workFrom', 'From'),
              input('workTo', 'To'),
              ElevatedButton(onPressed: addWork, child: const Text("Add Work")),
              ...workList.map((w) => ListTile(
                leading: const Icon(Icons.work),
                title: Text("${w['court']} (${w['from']} - ${w['to']})"),
              )),
            ],
            const SizedBox(height: 10),
            ScheduleBuilder(onScheduleChange: (data) => schedule = data),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.check_circle),
              onPressed: submitForm,
              label: const Text("Submit Application"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C2D3D),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
