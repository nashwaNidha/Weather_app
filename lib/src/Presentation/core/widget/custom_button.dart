import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.title,
    required this.onTap,
  });
  final String title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 140,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(173, 16, 29, 85)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                    color: Colors.white, fontSize: 18, letterSpacing: .5),
              ),
            ),
            const Icon(
              Icons.arrow_outward_rounded,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
