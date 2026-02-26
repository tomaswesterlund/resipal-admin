import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BodyText extends StatelessWidget {
  final String text;
  final double fontSize;
  final double lineHeight;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign? textAlign; // Added textAlign field

  const BodyText({
    super.key,
    required this.text,
    this.fontSize = 16.0,
    this.lineHeight = 1.5,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.black,
    this.textAlign, // Initialize in default constructor
  });

  const BodyText.large(
    this.text, {
    this.color = Colors.black,
    this.fontWeight = FontWeight.normal,
    this.textAlign, // Pass through named constructor
    super.key,
  })  : fontSize = 18.0,
        lineHeight = 28.0 / 18.0;

  const BodyText.medium(
    this.text, {
    this.color = Colors.black,
    this.fontWeight = FontWeight.normal,
    this.textAlign, // Pass through named constructor
    super.key,
  })  : fontSize = 16.0,
        lineHeight = 24.0 / 16.0;

  const BodyText.small(
    this.text, {
    this.color = Colors.black,
    this.fontWeight = FontWeight.normal,
    this.textAlign, // Pass through named constructor
    super.key,
  })  : fontSize = 14.0,
        lineHeight = 20.0 / 14.0;

  const BodyText.tiny(
    this.text, {
    this.color = Colors.black,
    this.fontWeight = FontWeight.normal,
    this.textAlign, // Pass through named constructor
    super.key,
  })  : fontSize = 12.0,
        lineHeight = 16.0 / 12.0;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign, // Applied to the Text widget
      style: GoogleFonts.raleway(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: lineHeight,
      ),
    );
  }
}