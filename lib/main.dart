import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart' as di;
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'features/review_feed/presentation/bloc/review_feed_bloc.dart';
import 'features/review_feed/presentation/bloc/review_feed_event.dart';
import 'features/share_review/presentation/bloc/share_review_bloc.dart';
import 'features/review_feed/presentation/pages/review_feed_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<ReviewFeedBloc>()..add(LoadReviewsEvent()),
        ),
        BlocProvider(
          create: (_) => di.sl<ShareReviewBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Airline Review',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const ReviewFeedPage(),
        onGenerateRoute: AppRoutes.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}