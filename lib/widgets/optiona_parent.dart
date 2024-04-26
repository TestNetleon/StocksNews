import 'package:flutter/material.dart';

class OptionalParent extends StatelessWidget {
  const OptionalParent({
    required this.addParent,
    required this.parentBuilder,
    required this.child,
    super.key,
  });

  final bool addParent;
  final Widget child;
  final Function(Widget child) parentBuilder;

  @override
  Widget build(BuildContext context) {
    return addParent ? parentBuilder(child) : child;
  }
}
