import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k_tv/focusable.dart';
import 'package:k_tv/screens/auth_screen.dart';

import 'providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
            user != null ? "Welcome ${user.displayName ?? ""}" : "Welcome"),
        actions: [
          ElevatedButton(
              onPressed: () {
                ref.read(authProvider.notifier).signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => AuthScreen()));
              },
              child: Text("logout "))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: GridView.builder(
            itemCount: 9,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, childAspectRatio: 16 / 9),
            itemBuilder: (context, index) {
              return FocusableWidget(
                onSelect: () => {},
                onFocus: () => print("Items $index focused"),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey,
                  ),
                  child: Center(
                    child: Text('Item: $index'),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
