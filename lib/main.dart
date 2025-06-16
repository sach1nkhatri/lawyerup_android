import 'package:flutter/material.dart';
import 'package:lawyerup_android/app/app.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/service_locater/service_locator.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // ✅ Open the settings box for app flags (e.g. firstLaunch)
  await Hive.openBox('settingsBox');

  // ✅ Initialize all services, cubits, etc.
  await initServiceLocator();

  runApp(const LawyerUpApp());
}
