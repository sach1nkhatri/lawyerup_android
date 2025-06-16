import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

// Splash Feature
import '../../features/auth/presentation/bloc/signup/signup_cubit.dart';
import '../../features/splash/data/datasources/local/splash_local_data_source.dart';
import '../../features/splash/data/datasources/local/splash_local_data_source_impl.dart';
import '../../features/splash/domain/usecases/check_first_launch.dart';
import '../../features/splash/presentation/bloc/splash_cubit.dart';

// Auth Feature (you'll need to adjust paths if different)
import '../../features/auth/data/data_source/remote_datasource/auth_remote_datasource.dart';
import '../../features/auth/data/data_source/remote_datasource/auth_remote_datasource_impl.dart';
import '../../features/auth/data/repository/remote_repository/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/signup_usecase.dart';
import '../../features/auth/presentation/bloc/login/login_cubit.dart';


final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  final settingsBox = Hive.box('settingsBox');

  // Splash Module
  sl.registerLazySingleton<SplashLocalDataSource>(
        () => SplashLocalDataSourceImpl(settingsBox: settingsBox),
  );
  sl.registerLazySingleton<CheckFirstLaunch>(() => CheckFirstLaunch(sl()));
  sl.registerFactory(() => SplashCubit(checkFirstLaunch: sl()));

  // 🔐 Auth Module

  // Data sources
  sl.registerLazySingleton<AuthRemoteDatasource>(
        () => AuthRemoteDatasourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignupUseCase(sl()));

  // Cubits
  sl.registerFactory(() => LoginCubit(sl()));
  sl.registerFactory(() => SignupCubit(sl()));
}
