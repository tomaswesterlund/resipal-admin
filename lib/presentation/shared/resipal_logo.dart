import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ResipalLogo extends StatelessWidget {
  const ResipalLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset('assets/resipal_logo_green.svg', semanticsLabel: 'Dart Logo');
  }
}