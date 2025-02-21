import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FocusableWidget extends StatefulWidget {
  const FocusableWidget({
    super.key,
    required this.child,
    required this.onSelect,
    this.onFocus,
    this.onUnFocus,
  });

  final Widget child;
  final VoidCallback onSelect;
  final VoidCallback? onFocus;
  final VoidCallback? onUnFocus;

  @override
  State<FocusableWidget> createState() => _FocusableWidgetState();
}

class _FocusableWidgetState extends State<FocusableWidget> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        widget.onFocus?.call();
      } else {
        widget.onUnFocus?.call;
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      onKeyEvent: (focusNode, event) {
        log('Focus has node: ${_focusNode.hasFocus}');
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.select) {
          widget.onSelect();
          return KeyEventResult.handled;
        }
        setState(() {});
        return KeyEventResult.ignored;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          border: _focusNode.hasFocus
              ? Border.all(color: Colors.white, width: 3)
              : null,
          borderRadius: BorderRadius.circular(8),
          boxShadow: _focusNode.hasFocus
              ? [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4))
                ]
              : null,
        ),
        child: widget.child,
      ),
    );
  }
}
