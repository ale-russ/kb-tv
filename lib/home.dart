import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:k_tv/focusable.dart';
import 'package:k_tv/providers/movei_provider.dart';
import 'package:k_tv/providers/side_bar_provider.dart';

import 'providers/auth_provider.dart';

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
              /*  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => AuthScreen())); */
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
              width: isSidebarVisible ? 50 : 200,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.brown,
                  )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FocusableWidget(
                    onFocus: () {},
                    onSelect: () {},
                    child: Container(
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: IconButton(
                        icon: Icon(Icons.person_2_rounded),
                        style:
                            IconButton.styleFrom(backgroundColor: Colors.black),
                        onPressed: () {
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
                          onSelect: () => {},
                          onFocus: () => print("Items $index focused"),
                          child: Card(
                              margin: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      movie.poster,
                                      fit: BoxFit.cover,
                                      width: width, height: height,
                                      // width: 150,
                                      // height: 90,
                                    ),
                                  ),
                                  // const SizedBox(height: 12),
                                  Flexible(
                                    child: Text(
                                      movie.title,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              )),
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
