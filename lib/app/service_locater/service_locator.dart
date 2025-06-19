import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

// AUTH
import '../../features/auth/data/datasources/remote_datasource/auth_remote_datasource.dart';
import '../../features/auth/data/datasources/remote_datasource/auth_remote_datasource_impl.dart';
import '../../features/auth/data/datasources/local_datasource/auth_local_datasource.dart';
import '../../features/auth/data/datasources/local_datasource/auth_local_datasource_impl.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/signup_usecase.dart';
import '../../features/auth/presentation/bloc/login_cubit.dart';
import '../../features/auth/presentation/bloc/signup_cubit.dart';

// SPLASH / ONBOARDING
import '../../features/onboarding/domain/repositories/splash_repository.dart';
import '../../features/onboarding/domain/repositories/splash_repository_impl.dart';
import '../../features/onboarding/domain/usecases/complete_onboarding.dart';
import '../../features/splash/data/datasources/local/splash_local_data_source.dart';
import '../../features/splash/data/datasources/local/splash_local_data_source_impl.dart';
import '../constant/hive_constants.dart';


final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // ✅ Splash/Onboarding Local Data Source (Hive injected)
  sl.registerLazySingleton<SplashLocalDataSource>(
        () => SplashLocalDataSourceImpl(
      settingsBox: Hive.box(HiveConstants.settingsBox),
    ),
  );

  // ✅ Splash Repository
  sl.registerLazySingleton<SplashRepository>(
        () => SplashRepositoryImpl(sl()),
  );

  // ✅ Splash Use Case
  sl.registerLazySingleton(() => CompleteOnboarding(sl()));

  // ✅ Auth Data Sources
  sl.registerLazySingleton<AuthRemoteDatasource>(() => AuthRemoteDatasourceImpl());
  sl.registerLazySingleton<AuthLocalDatasource>(() => AuthLocalDatasourceImpl());

  // ✅ Auth Repository
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      remoteDatasource: sl<AuthRemoteDatasource>(),
      localDatasource: sl<AuthLocalDatasource>(),
      useLocal: true, // Flip for Hive-only testing
    ),
  );

  // ✅ Auth Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignupUseCase(sl()));

  // ✅ Auth Cubits (ViewModels)
  sl.registerFactory(() => LoginCubit(sl()));
  sl.registerFactory(() => SignupCubit(sl()));
}
