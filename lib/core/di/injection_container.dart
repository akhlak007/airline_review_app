import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../network/network_info.dart';
import '../../features/review_feed/data/datasources/review_local_data_source.dart';
import '../../features/review_feed/data/datasources/review_remote_data_source.dart';
import '../../features/review_feed/data/repositories/review_repository_impl.dart';
import '../../features/review_feed/domain/repositories/review_repository.dart';
import '../../features/review_feed/domain/usecases/get_reviews.dart';
import '../../features/review_feed/presentation/bloc/review_feed_bloc.dart';

import '../../features/share_review/data/datasources/aviation_remote_data_source.dart';
import '../../features/share_review/data/repositories/aviation_repository_impl.dart';
import '../../features/share_review/domain/repositories/aviation_repository.dart';
import '../../features/share_review/domain/usecases/get_airlines.dart';
import '../../features/share_review/domain/usecases/get_airports.dart';
import '../../features/share_review/presentation/bloc/share_review_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Review Feed
  sl.registerFactory(() => ReviewFeedBloc(getReviews: sl()));
  sl.registerLazySingleton(() => GetReviews(sl()));
  sl.registerLazySingleton<ReviewRepository>(() => ReviewRepositoryImpl(
    remoteDataSource: sl(),
    localDataSource: sl(),
    networkInfo: sl(),
  ));
  sl.registerLazySingleton<ReviewRemoteDataSource>(() => ReviewRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<ReviewLocalDataSource>(() => ReviewLocalDataSourceImpl(sharedPreferences: sl()));

  // Features - Share Review
  sl.registerFactory(() => ShareReviewBloc(
    getAirlines: sl(),
    getAirports: sl(),
  ));
  sl.registerLazySingleton(() => GetAirlines(sl()));
  sl.registerLazySingleton(() => GetAirports(sl()));
  sl.registerLazySingleton<AviationRepository>(() => AviationRepositoryImpl(
    remoteDataSource: sl(),
    networkInfo: sl(),
  ));
  sl.registerLazySingleton<AviationRemoteDataSource>(() => AviationRemoteDataSourceImpl(client: sl()));

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
}