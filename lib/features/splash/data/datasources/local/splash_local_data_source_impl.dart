import 'package:hive/hive.dart';
import 'splash_local_data_source.dart';

class SplashLocalDataSourceImpl implements SplashLocalDataSource {
  final Box settingsBox;

  SplashLocalDataSourceImpl({required this.settingsBox});

  static const String _firstLaunchKey = 'firstLaunch';

  @override
  Future<bool> checkIfFirstLaunch() async {
    return settingsBox.get(_firstLaunchKey, defaultValue: true);
  }

  @override
  Future<void> completeOnboarding() async {
    await settingsBox.put(_firstLaunchKey, false);
  }
}
