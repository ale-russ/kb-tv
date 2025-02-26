import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k_tv/firebase_options.dart';
import 'package:k_tv/routes/app_routes.dart';
import 'package:k_tv/screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: const AndroidTVApp()));
}

class AndroidTVApp extends StatelessWidget {
  const AndroidTVApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'Android TV App',
    //   theme: ThemeData.dark(),
    //   home: FocusScope(child: const AuthScreen()),
    // );
    return MaterialApp.router(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      routerConfig: AppRoutes().router,
    );
  }
}
