import 'dart:async';
import 'dart:io';

import 'package:app/global/background_functions/new_player_results.dart';
import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/constants.dart';
import 'package:app/global/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
          // Allow only the problematic host
          if (host.contains('badmintonplayer.dk')) return true;
          return false;
        };
    return client;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterBackgroundService service = FlutterBackgroundService();

  if (Platform.isAndroid) {
    HttpOverrides.global = MyHttpOverrides();
  }

  onStart(service);

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://223aae453a25d79145a9bcf5ef421dfd@o4506016534102016.ingest.us.sentry.io/4506283562500096';
    },
    // Init your App.
    appRunner: () => runApp(const ProviderScope(child: MyApp())),
  );
}

void onStart(FlutterBackgroundService service) async {
  final notification = FlutterLocalNotificationsPlugin();

  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iosSettings = DarwinInitializationSettings();
  const settings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  // bool newPlayerResult = await newPlayerResults();
  await notification.initialize(settings);
  Timer.periodic(const Duration(hours: 12), (timer) async {
    bool newPlayerResult = await newPlayerResults();

    if (newPlayerResult) {
      // Send notification
      const androidDetails = AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        importance: Importance.high,
        priority: Priority.high,
      );
      const notificationDetails = NotificationDetails(android: androidDetails);
      await notification.show(
        0,
        'Nyt spiller resultat',
        'En af dine spillere har har fået nye point!',
        notificationDetails,
      );
    }
  });
}

final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorTheme = ref.watch(colorThemeProvider);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: MaterialApp(
        scaffoldMessengerKey: scaffoldKey,
        theme: ThemeData().copyWith(
          scaffoldBackgroundColor: colorTheme.backgroundColor,
          textTheme: TextTheme(
            bodyLarge: TextStyle(color: colorTheme.fontColor),
            bodyMedium: TextStyle(color: colorTheme.fontColor),
            bodySmall: TextStyle(color: colorTheme.fontColor),
            headlineLarge: TextStyle(color: colorTheme.fontColor),
            headlineMedium: TextStyle(color: colorTheme.fontColor),
            headlineSmall: TextStyle(color: colorTheme.fontColor),
            titleLarge: TextStyle(color: colorTheme.fontColor),
            titleMedium: TextStyle(color: colorTheme.fontColor),
            titleSmall: TextStyle(color: colorTheme.fontColor),
            labelLarge: TextStyle(color: colorTheme.fontColor),
            labelMedium: TextStyle(color: colorTheme.fontColor),
            labelSmall: TextStyle(color: colorTheme.fontColor),
          ),
        ),
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: const [Locale('da', 'DK')],
        // navigatorObservers: [
        //   SentryNavigatorObserver(),
        // ],
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
        navigatorKey: navKey,
      ),
    );
  }
}
