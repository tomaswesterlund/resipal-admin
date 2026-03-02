import 'package:flutter/material.dart';
import 'package:resipal_admin/presentation/onboarding/user_registration/onboarding_user_registration_page.dart';
import 'package:wester_kit/lib.dart';
import 'package:short_navigation/short_navigation.dart';

class OnboardingStartPage extends StatelessWidget {
  const OnboardingStartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: const MyAppBar(title: '¡Bienvenido a Resipal!', automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Welcome Section
            HeaderText.five(
              '¡Hola! Nos da gusto verte por aquí.',
              color: colorScheme.primary,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Como usuario nuevo, queremos que explores todas las herramientas de administración sin compromiso.',
              style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // 2. Free Tier Callout
            _buildTierCard(
              context,
              title: 'Prueba Gratuita',
              properties: 'Hasta 10 propiedades',
              price: 'GRATIS',
              isHighlight: true,
              description:
                  'Ideal para conocer la plataforma y registrar tus primeras unidades. Disfruta de todas las herramientas sin presiones.',
              footerItems: [
                {'icon': Icons.credit_card_off_rounded, 'text': 'Sin tarjeta de crédito'},
                {'icon': Icons.sync_disabled_rounded, 'text': 'Sin suscripción forzosa'},
              ],
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                label: 'Comenzar ahora', 
                onPressed: () => Go.to(const OnboardingUserRegistrationPage()),
              ),
            ),
            const SizedBox(height: 16),

            // 3. Paid Tiers
            const Divider(height: 40),
            Text(
              'Planes de Crecimiento',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold, 
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),

            _buildTierCard(context, title: 'Plan Estándar', properties: 'Hasta 100 propiedades', price: '\$599 MXN / mes'),
            const SizedBox(height: 12),
            _buildTierCard(context, title: 'Plan Profesional', properties: 'Hasta 200 propiedades', price: '\$999 MXN / mes'),
            const SizedBox(height: 24),

            // 4. Contact Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Column(
                children: [
                  Text(
                    '¿Necesitas más de 200 propiedades?',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  _buildContactLink(context, Icons.email_outlined, 'ventas@resipal.app'),
                  const SizedBox(height: 8),
                  _buildContactLink(context, Icons.chat_bubble_outline_rounded, '+52 XX XXXX XXXX'),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTierCard(
    BuildContext context, {
    required String title,
    required String properties,
    required String price,
    String? description,
    List<Map<String, dynamic>>? footerItems,
    bool isHighlight = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isHighlight ? colorScheme.primary.withOpacity(0.05) : colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isHighlight ? colorScheme.primary : colorScheme.outlineVariant,
          width: isHighlight ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title, 
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                price,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900, 
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            properties, 
            style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
          ),

          if (description != null) ...[
            const SizedBox(height: 12),
            Text(
              description, 
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant, 
                height: 1.4,
              ),
            ),
          ],

          if (footerItems != null) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: footerItems.map((item) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(item['icon'] as IconData, size: 16, color: colorScheme.primary),
                  const SizedBox(width: 6),
                  Text(
                    item['text'] as String,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContactLink(BuildContext context, IconData icon, String text) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 18, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}