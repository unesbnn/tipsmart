import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'commons/app_config.dart';
import 'commons/constants.dart';
import 'commons/themes.dart';
import 'features/ads/ads_manager.dart';
import 'features/authentication/blocs/authentication_bloc/authentication_bloc.dart';
import 'features/authentication/blocs/password_reset_cubit/password_reset_cubit.dart';
import 'features/authentication/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'features/authentication/repositories/authentication_repository.dart';
import 'features/notification/onesignal_notifications.dart';
import 'features/tips/blocs/fake_bets_cubit/fake_bets_cubit.dart';
import 'features/tips/blocs/tips_stats_cubit/tips_stats_cubit.dart';
import 'features/tips/models/balance_history.dart';
import 'features/tips/models/betting_statistics.dart';
import 'features/tips/models/fake_bet.dart';
import 'features/tips/models/tip_model.dart';
import 'features/tips/repositories/betslip_repository.dart';
import 'features/tips/repositories/fake_bets_repository.dart';
import 'features/tips/repositories/tips_repository.dart';
import 'firebase_options.dart';
import 'ui/screens/authentication/authentication_screen.dart';
import 'ui/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //Initialize ads
  await AdsManager.instance.initializeAds();

  //Initialize OneSignal Notifications
  await OneSignalNotification.initializeOneSignal();

  await AppConfig.getPackageInfo();

  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  //Initialize Hive
  await _initHive();

  runApp(MyApp(savedThemeMode: savedThemeMode));
}

Future<void> _initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TipAdapter());
  Hive.registerAdapter(FakeBetAdapter());
  Hive.registerAdapter(BettingStatisticsAdapter());
  Hive.registerAdapter(BalanceHistoryAdapter());
  Hive.registerAdapter(BalanceHistoryTypeAdapter());
  await Hive.openBox<int>(Constants.lastWatchTimestamp);
  await Hive.openBox<Tip>(Constants.simulatorBox);
  await Hive.openBox<FakeBet>(Constants.fakeBetsBox);
  await Hive.openBox<BettingStatistics>(Constants.bettingStatsBox);
  await Hive.openBox<BalanceHistory>(Constants.balanceHistoryBox);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.savedThemeMode});

  final AdaptiveThemeMode? savedThemeMode;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final FirebaseAnalytics analytics;
  late final NavigatorObserver observer;

  @override
  void initState() {
    super.initState();
    analytics = FirebaseAnalytics.instance;
    analytics.setAnalyticsCollectionEnabled(true);
    observer = FirebaseAnalyticsObserver(analytics: analytics);
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthenticationRepository()),
        RepositoryProvider(create: (context) => TipsRepository()),
        RepositoryProvider(create: (context) => BetSlipRepository()),
        RepositoryProvider(create: (context) => FakeBetsRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthenticationBloc(context.read<AuthenticationRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                SignInBloc(context.read<AuthenticationRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                PasswordResetCubit(context.read<AuthenticationRepository>()),
          ),
          BlocProvider(
            lazy: false,
            create: (context) =>
                TipsStatsCubit(context.read<TipsRepository>())..getTipsStats(),
          ),
          BlocProvider(
            lazy: false,
            create: (context) =>
                FakeBetsCubit(context.read<FakeBetsRepository>()),
          ),
        ],
        child: ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return AdaptiveTheme(
              light: AppThemes.lightTheme,
              dark: AppThemes.darkTheme,
              initial: widget.savedThemeMode ?? AdaptiveThemeMode.light,
              builder: (theme, darkTheme) {
                return BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, authState) {
                    final bool authenticated =
                        authState.status == AuthenticationStatus.authenticated;
                    return MaterialApp(
                      navigatorObservers: [observer],
                      title: AppConfig.name,
                      debugShowCheckedModeBanner: false,
                      theme: theme,
                      darkTheme: darkTheme,
                      home: authenticated
                          ? const HomeScreen()
                          : const AuthenticationScreen(),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
