
import 'package:hive/hive.dart';

class CompleteOnboarding {
  Future<void> call() async {
    final box = await Hive.openBox('settings');
    await box.put('tutorial_seen', true);
  }
}
