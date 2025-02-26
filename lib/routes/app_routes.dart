// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:k_tv/home.dart';
// import 'package:k_tv/screens/auth_screen.dart';
// import 'package:k_tv/screens/qr_login_screen.dart';

// class AppRoutes {
//   final GoRouter router = GoRouter(routes: [
//     GoRoute(
//         path: "/",
//         // name: "auth",
//         builder: (BuildContext context, GoRouterState state) => AuthScreen(),
//         routes: [
//           GoRoute(
//               path: "/auth",
//               name: "qr-login",
//               builder: (context, state) => QrLoginScreen())
//         ]),
//     GoRoute(
//       path: "/home",
//       name: "home",
//       builder: (BuildContext context, GoRouterState state) => HomeScreen(),
//     ),
//   ]);
// }

import 'package:go_router/go_router.dart';
import 'package:k_tv/home.dart';
import 'package:k_tv/screens/auth_screen.dart';
import 'package:k_tv/screens/qr_login_screen.dart';
import 'package:k_tv/screens/web_auth.dart';

class AppRoutes {
  final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: "/",
        builder: (context, state) => AuthScreen(),
        routes: [
          GoRoute(
            path: "qr-login", // Change from "/auth" to "auth"
            name: "qr-login",
            builder: (context, state) {
              final sessionId = state.uri.queryParameters['session'];
              return QrLoginScreen(sessionId: sessionId);
            },
          ),
          GoRoute(
            path: "auth", // Change from "/auth" to "auth"
            name: "auth",
            builder: (context, state) {
              final sessionId = state.uri.queryParameters['session'];
              return WebLoginPage(sessionId: sessionId);
            },
          ),
        ],
      ),
      GoRoute(
        path: "/home",
        name: "home",
        builder: (context, state) => HomeScreen(),
      ),
    ],
  );
}
