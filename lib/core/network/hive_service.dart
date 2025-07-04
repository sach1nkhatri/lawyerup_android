import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../../features/auth/data/models/user_hive_model.dart';

class HiveService {
  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init('${dir.path}/lawyerup.db');

    Hive.registerAdapter(UserHiveModelAdapter());

    await Hive.openBox<UserHiveModel>('users');
    await Hive.openBox('settingsBox');
  }

  Future<void> clearAll() async {
    await Hive.deleteBoxFromDisk('users');
    await Hive.deleteBoxFromDisk('settingsBox');
  }
}
