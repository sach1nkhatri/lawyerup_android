import 'package:flutter/material.dart';
import 'package:lawyerup_android/app/app.dart';
import 'core/network/hive_network_service.dart'; // teacher-style
import 'app/service_locater/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final hiveService = HiveService();
  await hiveService.init();

  await initServiceLocator(); //Where are you my little services

  runApp(const LawyerUpApp());
}
