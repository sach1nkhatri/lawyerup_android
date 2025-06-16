import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource_impl.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/signup_usecase.dart';
import '../../features/auth/presentation/bloc/login_cubit.dart';
import '../../features/auth/presentation/bloc/signup_cubit.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // ✅ Data Sources
  sl.registerLazySingleton<AuthRemoteDatasource>(() => AuthRemoteDatasourceImpl());

  // ✅ Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // ✅ Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignupUseCase(sl()));

  // ✅ Cubits (ViewModels)
  sl.registerFactory(() => LoginCubit(sl()));
  sl.registerFactory(() => SignupCubit(sl()));
}
