import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/entities/user_status.dart';
import 'splash_local_data_source.dart';

class SplashLocalDataSourceImpl implements SplashLocalDataSource {
  @override
  Future<UserStatus> getUserStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? seenTutorial = prefs.getBool('seen_tutorial');
    final bool? isLoggedIn = prefs.getBool('is_logged_in');

    if (isLoggedIn == true) return UserStatus.loggedIn;
    if (seenTutorial == true) return UserStatus.tutorialCompleted;
    return UserStatus.firstTime;
  }
}
