import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/src/Presentation/core/constants/theme/color.dart';

class LocationText extends StatelessWidget {
  const LocationText({
    super.key,
    required this.location,
  });

  final String location;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Image(
          image: AssetImage('assets/location_icon.png'),
          height: 40,
          width: 40,
        ),
        Text(
          location,
          style: GoogleFonts.lato(
              textStyle: const TextStyle(fontSize: 35, letterSpacing: .5),
              color: AppColors.lightBlue),
        ),
      ],
    );
  }
}
