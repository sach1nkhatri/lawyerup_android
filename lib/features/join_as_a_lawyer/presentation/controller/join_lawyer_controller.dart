import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../../../../app/constant/hive_constants.dart';
import '../../../../app/constant/api_endpoints.dart';
import '../../../auth/data/models/user_hive_model.dart';
import '../pages/lawyer_status_page.dart';
import 'lawyer_user_checker.dart';

class JoinLawyerController {
  final BuildContext context;

  final form = <String, dynamic>{};
  List<Map<String, String>> educationList = [];
  List<Map<String, String>> workList = [];
  Map<String, List<Map<String, String>>> schedule = {};
  File? profileImage;
  File? licenseFile;

  JoinLawyerController(this.context);

  /// Checks if current user is already a lawyer and opens the status page if true
  Future<void> checkIfAlreadyLawyer() async {
    final lawyer = await LawyerUserChecker.getLawyerByMe(); // ✅ uses /lawyers/me
    if (lawyer != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LawyerStatusPage(lawyer: lawyer)),
      );
    }
  }

  /// Populate form fields from existing lawyer data (used for edit)
  void populateFromExistingLawyer(Map<String, dynamic> lawyer) {
    form['fullName'] = lawyer['fullName'] ?? '';
    form['specialization'] = lawyer['specialization'] ?? '';
    form['qualification'] = lawyer['qualification'] ?? '';
    form['email'] = lawyer['email'] ?? '';
    form['phone'] = lawyer['phone'] ?? '';
    form['state'] = lawyer['state'] ?? '';
    form['city'] = lawyer['city'] ?? '';
    form['address'] = lawyer['address'] ?? '';
    form['expectedGraduation'] = lawyer['expectedGraduation'] ?? '';
    form['description'] = lawyer['description'] ?? '';
    form['specialCase'] = lawyer['specialCase'] ?? '';
    form['socialLink'] = lawyer['socialLink'] ?? '';

    if (lawyer['education'] is List) {
      educationList = List<Map<String, String>>.from(
        lawyer['education'].map((e) => Map<String, String>.from(e)),
      );
    }

    if (lawyer['workExperience'] is List) {
      workList = List<Map<String, String>>.from(
        lawyer['workExperience'].map((w) => Map<String, String>.from(w)),
      );
    }

    if (lawyer['schedule'] is Map) {
      schedule = Map<String, List<Map<String, String>>>.from(
        lawyer['schedule'].map((day, slots) => MapEntry(
          day,
          List<Map<String, String>>.from(slots.map((slot) => Map<String, String>.from(slot))),
        )),
      );
    }
  }

  void updateFormValue(String key, dynamic value) {
    form[key] = value;
  }

  void setSchedule(Map<String, List<Map<String, String>>> data) {
    schedule = data;
  }

  void addEducation(Map<String, String> edu) {
    educationList.add(edu);
  }

  void addWork(Map<String, String> work) {
    workList.add(work);
  }

  void setProfileImage(File file) {
    profileImage = file;
  }

  void setLicenseFile(File file) {
    licenseFile = file;
  }

  Future<void> submitApplication({required bool isJunior}) async {
    final box = Hive.box<UserHiveModel>(HiveConstants.userBox);
    final user = box.get(HiveConstants.userKey);
    final token = user?.token;
    final uid = user?.uid;

    if (token == null || uid == null) return;

    final uri = Uri.parse(ApiEndpoints.createLawyer);
    final request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer $token';

    request.fields['user'] = uid;
    request.fields['role'] = isJunior ? 'junior' : 'senior';

    // Form fields
    form.forEach((key, value) {
      request.fields[key] = value?.toString() ?? '';
    });

    request.fields['education'] = jsonEncode(educationList);
    request.fields['workExperience'] = jsonEncode(workList);
    request.fields['schedule'] = jsonEncode(schedule);

    if (profileImage != null) {
      request.files.add(await http.MultipartFile.fromPath('profilePhoto', profileImage!.path));
    }

    if (licenseFile != null) {
      request.files.add(await http.MultipartFile.fromPath('licenseFile', licenseFile!.path));
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 201) {
      final lawyer = jsonDecode(response.body);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LawyerStatusPage(lawyer: lawyer)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to submit lawyer form")),
      );
    }
  }
}
