import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:k_tv/focusable.dart';
import 'package:k_tv/providers/movei_provider.dart';
import 'package:k_tv/providers/side_bar_provider.dart';

import '../../providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final user = ref.watch(authProvider);
    final isSidebarVisible = ref.watch(sidebarVisibilityProvider);
    final moviesAsyncValue = ref.watch(movieProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(user != null
            ? "Welcome ${user.displayName ?? user.email}"
            : "Welcome"),
        actions: [
          ElevatedButton(
            onPressed: () {
              ref.read(authProvider.notifier).signOut();
              context.pushReplacement("/");
            },
            child: Text("logout "),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              width: !isSidebarVisible ? 50 : 200,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.brown,
                  )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FocusableWidget(
                    onFocus: () {
                      ref.read(sidebarVisibilityProvider.notifier).state = true;
                    },
                    onUnFocus: () {
                      ref.read(sidebarVisibilityProvider.notifier).state =
                          false;
                    },
                    onSelect: () {
                      log("Enter Key is Pressed!");
                    },
                    child: Container(
                      width: isSidebarVisible
                          ? width
                          : 50, // Full width when expanded, 50px when collapsed
                      height: isSidebarVisible
                          ? null
                          : 50, // Maintain a square when collapsed

                      alignment: isSidebarVisible
                          ? Alignment.centerLeft
                          : Alignment.center,
                      // width: width,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(isSidebarVisible ? 8 : 100),
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      child: IconButton(
                        iconSize: isSidebarVisible ? 24 : 20,
                        icon: Icon(Icons.person_2_rounded),
                        style:
                            IconButton.styleFrom(backgroundColor: Colors.black),
                        onPressed: () {
                          log("buttonPressed");
                          ref.read(sidebarVisibilityProvider.notifier).state =
                              !isSidebarVisible;
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.brown)),
              child: moviesAsyncValue.when(
                data: (movies) {
                  return GridView.builder(
                      itemCount: movies.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, childAspectRatio: 16 / 9),
                      itemBuilder: (context, index) {
                        final movie = movies[index];

                        return FocusableWidget(
                          onSelect: () {
                            log("Title: ${movie.imdbID}");
                            ref.read(movieDetailProvider.notifier).state =
                                movie;
                            context.go(
                                "/home/movie-details?movie-id=${movie.imdbID}");
                          },
                          onFocus: () => {},
                          child: InkWell(
                            autofocus: false,
                            onTap: () {
                              ref.read(movieDetailProvider.notifier).state =
                                  movie;
                              context.go(
                                  "/home/movie-details?movie-id=${movie.imdbID}");
                            },
                            child: Card(
                                margin: const EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Image.network(
                                        movie.poster,
                                        fit: BoxFit.cover,
                                        width: 300,
                                        height: 320,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Icon(Icons.broken_image,
                                              size: 100, color: Colors.red);
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Flexible(
                                      child: Text(
                                        movie.title,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        );
                      });
                },
                error: (error, stackTrace) =>
                    Center(child: Text("Error: $error")),
                loading: () => Center(child: CircularProgressIndicator()),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
