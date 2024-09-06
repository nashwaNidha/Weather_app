import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;
  const CustomContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              // color: Colors.white,
              color: const Color(0x00000099),
              borderRadius: BorderRadius.circular(10),
              // boxShadow: []],
              border: Border.all(color: Colors.white70)),
          child: child,
        ));
  }
}
