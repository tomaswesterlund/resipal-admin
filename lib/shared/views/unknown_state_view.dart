import 'package:flutter/material.dart';
import 'package:resipal_core/presentation/shared/texts/header_text.dart';
import 'package:resipal_core/presentation/shared/texts/body_text.dart';

class UnknownStateView extends StatelessWidget {
  final VoidCallback? onTap;
  const UnknownStateView({this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Using a subtle grey icon to represent an "empty" or "unknown" state
            Icon(
              Icons.help_outline_rounded,
              color: Colors.grey.shade400,
              size: 80,
            ),
            const SizedBox(height: 24),

            // Primary Message
            const HeaderText.three('Estado Desconocido', color: Colors.black87),
            const SizedBox(height: 8),

            // Secondary Helper Text
            const BodyText.medium(
              'No pudimos determinar la información a mostrar. Por favor, intenta recargar la pantalla.',
              color: Colors.grey,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            if (onTap != null)
              ElevatedButton.icon(
                onPressed: () {
                  // Logic to reload or navigate back
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Recargar'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
