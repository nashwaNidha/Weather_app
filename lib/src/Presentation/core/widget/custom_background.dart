import 'package:flutter/material.dart';
import 'package:weather_app/src/Presentation/core/constants/theme/color.dart';

class CustomBackground extends StatelessWidget {
  final Widget child;
  const CustomBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.topRight,
          //   end: Alignment.bottomLeft,
          //   stops: [0.1, 0.5, 0.7, 0.9],
          //   colors: <Color>[
          //     Color.fromARGB(255, 22, 82, 131),
          //     Color.fromARGB(250, 40, 155, 219),
          //     Color.fromARGB(255, 25, 127, 210),
          //     Color.fromARGB(255, 68, 127, 169),
          //   ],
          // ),
          color: AppColors.primaryColor,
        ),
        child: child);
  }
}
