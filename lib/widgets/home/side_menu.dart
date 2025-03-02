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
    {"icon": Icons.person_2_rounded, "title": "User"},
    {"icon": Icons.home_filled, "title": "Home"},
    {"icon": Icons.tv_outlined, "title": "Movies"},
    {"icon": Icons.search, "title": "Search"},
    {"icon": Icons.add, "title": "Library"},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;
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
            icon: icons[index]['icon'] as IconData,
            title: icons[index]['title'] as String,
            // icon: icons[index],
          ),
        ),
      ),
    );
  }
}

class MenuItems extends ConsumerWidget {
  const MenuItems({super.key, required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;
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
            child: Row(
              children: [
                Icon(
                  icon,
                  size: isSidebarVisible ? 25 : 15,
                ),
                isSidebarVisible
                    ? const SizedBox(width: 5)
                    : const SizedBox.shrink(),
                isSidebarVisible
                    ? Text(
                        title,
                        style: TextStyle(color: Colors.white),
                      )
                    : const SizedBox.shrink()
              ],
            )),
      ),
    );
  }
}
