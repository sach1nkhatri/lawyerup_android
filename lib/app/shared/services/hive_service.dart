import 'package:hive_flutter/hive_flutter.dart';
import '../../constant/hive_constants.dart';

class HiveService {
  Future<void> init() async {
    await Hive.initFlutter();

    // 🧠 Open all required boxes before usage
    await Hive.openBox(HiveConstants.userBox);
    await Hive.openBox(HiveConstants.settingsBox);

    // Optional: register adapters here if you use any
    // Hive.registerAdapter(UserAdapter());
  }
}
