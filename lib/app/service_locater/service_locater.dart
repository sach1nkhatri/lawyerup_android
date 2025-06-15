import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../../features/splash/data/datasources/local/splash_local_data_source.dart';
import '../../features/splash/data/datasources/local/splash_local_data_source_impl.dart';
import '../../features/splash/domain/usecases/check_first_launch.dart'; // ✅ Import this!
import '../../features/splash/presentation/bloc/splash_cubit.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // Retrieve the settings box (opened in main.dart)
  final settingsBox = Hive.box('settingsBox');

  // Data sources
  sl.registerLazySingleton<SplashLocalDataSource>(
        () => SplashLocalDataSourceImpl(settingsBox: settingsBox),
  );

  // Use cases
  sl.registerLazySingleton<CheckFirstLaunch>(
        () => CheckFirstLaunch(sl()),
  );

  // Cubits
  sl.registerFactory(() => SplashCubit(checkFirstLaunch: sl()));
}
