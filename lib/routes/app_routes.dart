import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:k_tv/models/movie_details_model.dart';
import 'package:k_tv/screens/home/home.dart';
import 'package:k_tv/screens/auth/auth_screen.dart';
import 'package:k_tv/screens/auth/qr_login_screen.dart';
import 'package:k_tv/screens/auth/web_auth.dart';
import 'package:k_tv/screens/home/movie/movie_details.dart';
import 'package:k_tv/screens/video/video_play.dart';

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
        routes: [
          GoRoute(
              path: "movie-details",
              name: "movie-details",
              builder: (context, state) {
                String movieId = state.uri.queryParameters['movie-id']!;

                if (movieId == "") {
                  return Scaffold(
                    body: Center(
                      child: Text("Movie Data Is Missing"),
                    ),
                  );
                }

                return MovieDetailsPage(
                  movieId: movieId,
                );
              },
              routes: [
                GoRoute(
                  path: "video-player",
                  name: 'video-player',
                  builder: (context, state) {
                    final movie = state.extra as MovieDetailsModel;
                    return VideoPlayerPage(movieDetails: movie);
                  },
                ),
              ])
        ],
      ),
    ],
  );
}
