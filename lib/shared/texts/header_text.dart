import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign? textAlign; // Added field

  const HeaderText({
    super.key,
    required this.text,
    this.fontSize = 18.0,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.black,
    this.textAlign, // Initialize in default constructor
  });

    const HeaderText.giga(
    this.text, {
    this.color = Colors.black,
    this.fontWeight = FontWeight.bold,
    this.textAlign,
    super.key,
  }) : fontSize = 48.0;

  const HeaderText.one(
    this.text, {
    this.color = Colors.black,
    this.fontWeight = FontWeight.bold,
    this.textAlign, // Pass through named constructor
    super.key,
  }) : fontSize = 32.0;

  const HeaderText.two(
    this.text, {
    this.color = Colors.black,
    this.fontWeight = FontWeight.bold,
    this.textAlign, // Pass through named constructor
    super.key,
  }) : fontSize = 24.0;

  const HeaderText.three(
    this.text, {
    this.color = Colors.black,
    this.fontWeight = FontWeight.bold,
    this.textAlign, // Pass through named constructor
    super.key,
  }) : fontSize = 20.0;

  const HeaderText.four(
    this.text, {
    this.color = Colors.black,
    this.fontWeight = FontWeight.bold,
    this.textAlign, // Pass through named constructor
    super.key,
  }) : fontSize = 18.0;

  const HeaderText.five(
    this.text, {
    this.color = Colors.black,
    this.fontWeight = FontWeight.bold,
    this.textAlign, // Pass through named constructor
    super.key,
  }) : fontSize = 16.0;

  const HeaderText.six(
    this.text, {
    this.color = Colors.black,
    this.fontWeight = FontWeight.bold,
    this.textAlign, // Pass through named constructor
    super.key,
  }) : fontSize = 14.0;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign, // Applied here
      style: GoogleFonts.raleway(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}