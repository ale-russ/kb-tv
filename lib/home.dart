import 'package:flutter/material.dart';
import 'package:k_tv/focusable.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
