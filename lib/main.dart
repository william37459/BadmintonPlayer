import 'package:app/global/constants.dart';
import 'package:app/global/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://223aae453a25d79145a9bcf5ef421dfd@o4506016534102016.ingest.sentry.io/4506283562500096';
      options.tracesSampleRate = 1.0;
    },
    // Init your App.
    appRunner: () => runApp(
      const ProviderScope(
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: MaterialApp(
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: const [
          Locale('da', 'DK'),
        ],
        navigatorObservers: [
          SentryNavigatorObserver(),
        ],
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
        navigatorKey: navKey,
      ),
    );
  }
}
