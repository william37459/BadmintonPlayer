import 'dart:async';

import 'package:app/global/background_functions/new_player_results.dart';
import 'package:app/global/constants.dart';
import 'package:app/global/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterBackgroundService service = FlutterBackgroundService();

  onStart(service);
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

void onStart(FlutterBackgroundService service) async {
  final notification = FlutterLocalNotificationsPlugin();

  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iosSettings = DarwinInitializationSettings();
  const settings =
      InitializationSettings(android: androidSettings, iOS: iosSettings);

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: MaterialApp(
        theme: ThemeData().copyWith(
          scaffoldBackgroundColor: const Color(0xffF1F0F5),
        ),
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: const [
          Locale('da', 'DK'),
        ],
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
