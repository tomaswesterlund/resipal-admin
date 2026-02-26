import 'package:flutter/material.dart';
import 'package:resipal_core/presentation/shared/texts/header_text.dart';
import 'package:resipal_core/presentation/shared/texts/body_text.dart';

class AccessDeniedView extends StatelessWidget {
  const AccessDeniedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Using a "lock" or "security" icon to signal restriction
            const Icon(
              Icons.admin_panel_settings_outlined,
              color: Colors.blueGrey,
              size: 64,
            ),
            const SizedBox(height: 16),

            // Main Message
            HeaderText.three('Acceso restringido', color: Colors.black87, textAlign: TextAlign.center,),
            const SizedBox(height: 4),

            // Explanation
            BodyText.large('Se requieren permisos de administrador.', textAlign: TextAlign.center,),
            const SizedBox(height: 8),

            // Guidance
            BodyText.tiny(
              'Esta sección es exclusiva para el personal autorizado. '
              'Si crees que esto es un error, contacta a tu soporte técnico.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
