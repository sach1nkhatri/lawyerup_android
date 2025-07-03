import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

//NEWS
import '../../features/bookings/data/datasources/remote_datasource/booking_remote_data_source.dart';
import '../../features/bookings/data/datasources/remote_datasource/booking_repository_impl.dart';
import '../../features/bookings/domain/repositories/booking_repository.dart';
import '../../features/bookings/domain/usecases/create_booking.dart';
import '../../features/bookings/domain/usecases/delete_booking.dart';
import '../../features/bookings/domain/usecases/get_available_slots.dart';
import '../../features/bookings/domain/usecases/get_lawyer_bookings.dart';
import '../../features/bookings/domain/usecases/get_messages.dart';
import '../../features/bookings/domain/usecases/get_user_bookings.dart';
import '../../features/bookings/domain/usecases/mark_messages_as_read.dart';
import '../../features/bookings/domain/usecases/send_message.dart';
import '../../features/bookings/domain/usecases/update_booking_status.dart';
import '../../features/bookings/domain/usecases/update_meeting_link.dart';
import '../../features/bookings/presentation/bloc/booking_bloc.dart';
import '../../features/lawyer_up/data/datasources/remote/lawyer_remote_data_source.dart';
import '../../features/lawyer_up/data/repositories/lawyer_repository_impl.dart';
import '../../features/lawyer_up/domain/repositories/lawyer_repository.dart';
import '../../features/lawyer_up/domain/usecases/get_all_lawyers.dart';
import '../../features/lawyer_up/domain/usecases/get_lawyer_detail.dart';
import '../../features/lawyer_up/presentation/bloc/lawyer_list_bloc.dart';
import '../../features/news/presentation/bloc/news_preview_bloc.dart';
//DIO
import '../../core/network/dio_client.dart';
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
import '../../features/news/data/datasources/remote/news_remote_data_source.dart';
import '../../features/news/data/datasources/remote/news_remote_data_source_impl.dart';
import '../../features/news/data/repositories/news_repository_impl.dart';
import '../../features/news/domain/repositories/news_repository.dart';
import '../../features/news/domain/usecases/get_all_news.dart';
import '../../features/news/presentation/bloc/news_bloc.dart';
import '../../features/onboarding/domain/repositories/splash_repository.dart';
import '../../features/onboarding/domain/repositories/splash_repository_impl.dart';
import '../../features/onboarding/domain/usecases/complete_onboarding.dart';
import '../../features/pdf_library/data/datasources/remote/pdf_remote_datasource.dart';
import '../../features/pdf_library/data/datasources/remote/pdf_repository_impl.dart';
import '../../features/pdf_library/domain/repositories/pdf_repository.dart';
import '../../features/pdf_library/domain/usecases/get_all_pdfs_usecase.dart';
import '../../features/pdf_library/presentation/bloc/pdf_bloc.dart';
import '../../features/splash/data/datasources/local/splash_local_data_source.dart';
import '../../features/splash/data/datasources/local/splash_local_data_source_impl.dart';
import '../constant/hive_constants.dart';


final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // Splash/Onboarding Local Data Source (Hive injected)
  sl.registerLazySingleton<SplashLocalDataSource>(
        () => SplashLocalDataSourceImpl(
      settingsBox: Hive.box(HiveConstants.settingsBox),
    ),
  );

  // Splash Repository
  sl.registerLazySingleton<SplashRepository>(
        () => SplashRepositoryImpl(sl()),
  );

  // Splash Use Case
  sl.registerLazySingleton(() => CompleteOnboarding(sl()));

  // Auth Data Sources
  sl.registerLazySingleton<AuthRemoteDatasource>(() => AuthRemoteDatasourceImpl());
  sl.registerLazySingleton<AuthLocalDatasource>(() => AuthLocalDatasourceImpl());

  // Auth Repository
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      remoteDatasource: sl<AuthRemoteDatasource>(),
      localDatasource: sl<AuthLocalDatasource>(),
      useLocal: false, // Flip for Hive-only testing
    ),
  );

  // Auth Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignupUseCase(sl()));

  // Auth Cubits (ViewModels)
  sl.registerFactory(() => LoginCubit(sl()));
  sl.registerFactory(() => SignupCubit(sl()));


  // HTTP Client (shared)
  sl.registerLazySingleton(() => http.Client());

  // News Data Source
  sl.registerLazySingleton<NewsRemoteDataSource>(
        () => NewsRemoteDataSourceImpl(sl()),
  );

  // News Repository
  sl.registerLazySingleton<NewsRepository>(
        () => NewsRepositoryImpl(sl()),
  );

  // News Use Case
  sl.registerLazySingleton(() => GetAllNews(sl()));

  // News Bloc
  sl.registerFactory(() => NewsBloc(sl()));
  // DIO
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<Dio>(() => sl<DioClient>().dio);

  // News Preview Bloc (needs token and userId passed at runtime)
  sl.registerFactoryParam<NewsPreviewBloc, String, String>(
        (token, userId) => NewsPreviewBloc(token: token, userId: userId),
  );

// Lawyer Feature

// Data Source
  sl.registerLazySingleton<LawyerRemoteDataSource>(
        () => LawyerRemoteDataSourceImpl(sl()), // Dio is already registered above
  );

// Repository
  sl.registerLazySingleton<LawyerRepository>(
        () => LawyerRepositoryImpl(sl()),
  );

// Use Case
  sl.registerLazySingleton(() => GetAllLawyers(sl()));

// BLoC
  sl.registerFactory(() => LawyerListBloc(sl()));


  // PDF Feature

// Data Source
  sl.registerLazySingleton<PdfRemoteDataSource>(() => PdfRemoteDataSource(sl()));

// Repository
  sl.registerLazySingleton<PdfRepository>(() => PdfRepositoryImpl(sl()));

// Use Case
  sl.registerLazySingleton(() => GetAllPdfsUseCase(sl()));

// Bloc
  sl.registerFactory(() => PdfBloc(sl()));


  // ==================== BOOKINGS ====================
  // Data Source
  sl.registerLazySingleton<BookingRemoteDataSource>(() => BookingRemoteDataSource(dio: sl()));

  // Repository
  sl.registerLazySingleton<BookingRepository>(() => BookingRepositoryImpl(remote: sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetUserBookings(sl()));
  sl.registerLazySingleton(() => GetLawyerBookings(sl()));
  sl.registerLazySingleton(() => CreateBooking(sl()));
  sl.registerLazySingleton(() => DeleteBooking(sl()));
  sl.registerLazySingleton(() => UpdateBookingStatus(sl()));
  sl.registerLazySingleton(() => UpdateMeetingLink(sl()));
  sl.registerLazySingleton(() => GetAvailableSlots(sl()));
  sl.registerLazySingleton(() => GetMessages(sl()));
  sl.registerLazySingleton(() => SendMessage(sl()));
  sl.registerLazySingleton(() => MarkMessagesAsRead(sl()));

  // Bloc
  sl.registerFactory(() => BookingBloc(
    getUserBookings: sl(),
    getLawyerBookings: sl(),
    deleteBooking: sl(),
    updateBookingStatus: sl(),
  ));

}
