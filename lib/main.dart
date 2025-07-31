import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'core/network/hive_network_service.dart';
import 'app/service_locater/service_locator.dart';
import 'app/app.dart';
import 'features/report/presentation/pages/report_bottom_sheet.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔒 Lock to portrait mode only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  final hiveService = HiveService();
  await hiveService.init();

  await initServiceLocator();

  runApp(const LawyerUpRoot());
}

class LawyerUpRoot extends StatefulWidget {
  const LawyerUpRoot({super.key});

  @override
  State<LawyerUpRoot> createState() => _LawyerUpRootState();
}

class _LawyerUpRootState extends State<LawyerUpRoot> {
  @override
  void initState() {
    super.initState();
    _startShakeListener();
  }

  void _startShakeListener() {
    userAccelerometerEvents.listen((event) {
      final g = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      if (g > 15) {
        _showReportBottomSheet();
      }
    });
  }

  void _showReportBottomSheet() {
    final context = navigatorKey.currentContext;
    if (context != null) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => ReportBottomSheet(
          onClose: () => Navigator.of(context).pop(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const LawyerUpApp(); // 👈 Real app
  }
}
