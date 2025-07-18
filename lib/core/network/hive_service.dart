import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../../features/auth/data/models/user_hive_model.dart';
import '../../app/constant/hive_constants.dart';

class HiveService {
  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init('${dir.path}/lawyerup.db');

    if (!Hive.isAdapterRegistered(HiveConstants.userTypeId)) {
      Hive.registerAdapter(UserHiveModelAdapter());
    }

    if (!Hive.isBoxOpen(HiveConstants.userBox)) {
      await Hive.openBox<UserHiveModel>(HiveConstants.userBox);
    }

    if (!Hive.isBoxOpen(HiveConstants.settingsBox)) {
      await Hive.openBox(HiveConstants.settingsBox);
    }
  }

  Future<void> clearAll() async {
    await Hive.deleteBoxFromDisk(HiveConstants.userBox);
    await Hive.deleteBoxFromDisk(HiveConstants.settingsBox);
  }
}

