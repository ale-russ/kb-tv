import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'package:k_tv/firebase_options.dart';
import 'package:k_tv/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  usePathUrlStrategy();
  runApp(ProviderScope(child: const AndroidTVApp()));
}

class AndroidTVApp extends StatelessWidget {
  const AndroidTVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      routerConfig: AppRoutes().router,
    );
  }
}
