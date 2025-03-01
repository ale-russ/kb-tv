import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../../providers/movei_provider.dart';
import '../../providers/side_bar_provider.dart';
import '../../widgets/home/side_menu.dart';
import '../../widgets/home/movie_grid.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);

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
            SideMenu(),
            const SizedBox(),
            MovieGrid(moviesAsyncValue: moviesAsyncValue),
          ],
        ),
      ),
    );
  }
}
