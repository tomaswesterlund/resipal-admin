import 'package:flutter/material.dart';
import 'package:resipal_core/presentation/shared/texts/header_text.dart';
import 'package:resipal_core/presentation/shared/texts/body_text.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 64),
            const SizedBox(height: 16),

            // Main user-friendly message
            HeaderText.three('Oops!', color: Colors.black87),
            const SizedBox(height: 4),
            BodyText.large('Algo no salió como esperábamos.'),
            const SizedBox(height: 8),
            BodyText.tiny('Ya notificamos a nuestro equipo y estamos trabajando en ello.', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
