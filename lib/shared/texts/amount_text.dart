import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resipal_core/helpers/formatters/currency_formatter.dart';

class AmountText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight; // Added field

  const AmountText(
    this.text, {
    this.fontSize = 48.0,
    this.color = Colors.black,
    this.fontWeight = FontWeight.bold, // Defaulted to bold
    super.key,
  });

  AmountText.fromDouble(
    double amount, {
    this.fontSize = 48.0,
    this.color = Colors.black,
    this.fontWeight = FontWeight.bold,
    super.key,
  }) : text = CurrencyFormatter.fromDouble(amount);

  AmountText.fromInt(
    int amount, {
    this.fontSize = 48.0,
    this.color = Colors.black,
    this.fontWeight = FontWeight.bold,
    super.key,
  }) : text = CurrencyFormatter.fromDouble(amount.toDouble());

  AmountText.fromCents(
    int amount, {
    this.fontSize = 48.0,
    this.color = Colors.black,
    this.fontWeight = FontWeight.bold,
    super.key,
  }) : text = CurrencyFormatter.fromCents(amount);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.notoSansMono(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight, // Applied here
      ),
    );
  }
}
