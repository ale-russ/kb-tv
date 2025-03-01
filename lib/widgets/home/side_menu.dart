import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../focusable.dart';
import '../../providers/side_bar_provider.dart';

class SideMenu extends ConsumerWidget {
  SideMenu({
    super.key,
  });

  final icons = [
    Icons.person_2_rounded,
    Icons.home_filled,
    Icons.tv_outlined,
    Icons.search,
    Icons.add,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final isSidebarVisible = ref.watch(sidebarVisibilityProvider);
    return Container(
      width: !isSidebarVisible ? 50 : 200,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        // border: Border.all(color: Colors.brown)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          icons.length,
          (index) => MenuItems(
            icon: icons[index],
          ),
        ),
      ),
    );
  }
}

class MenuItems extends ConsumerWidget {
  const MenuItems({
    super.key,
    required this.icon,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final isSidebarVisible = ref.watch(sidebarVisibilityProvider);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: FocusableWidget(
        onFocus: () {
          ref.read(sidebarVisibilityProvider.notifier).state = true;
        },
        onUnFocus: () {
          ref.read(sidebarVisibilityProvider.notifier).state = false;
        },
        onSelect: () {
          log("Enter Key is Pressed!");
        },
        child: Container(
            padding: const EdgeInsets.all(8),
            width: isSidebarVisible ? width : 40,
            height: 40,
            alignment:
                isSidebarVisible ? Alignment.centerLeft : Alignment.center,
            // width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(isSidebarVisible ? 8 : 100),
            ),
            child: Icon(
              icon,
              size: isSidebarVisible ? 25 : 15,
            )),
      ),
    );
  }
}
