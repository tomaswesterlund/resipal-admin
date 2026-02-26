import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resipal_admin/presentation/onboarding/user_registration/onboarding_user_registration_page.dart';
import 'package:resipal_admin/shared/buttons/primary_cta_button.dart';
import 'package:resipal_core/presentation/shared/colors/base_app_colors.dart';
import 'package:resipal_core/presentation/shared/my_app_bar.dart';
import 'package:resipal_core/presentation/shared/texts/header_text.dart';
import 'package:short_navigation/short_navigation.dart';

class OnboardingStartPage extends StatelessWidget {
  const OnboardingStartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaseAppColors.background,
      appBar: const MyAppBar(title: '¡Bienvenido a Resipal!', automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Welcome Section
            HeaderText.five(
              '¡Hola! Nos da gusto verte por aquí.',
              color: const Color(0xFF1A4644),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Como usuario nuevo, queremos que explores todas las herramientas de administración sin compromiso.',
              style: GoogleFonts.raleway(fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // 2. Free Tier Callout
            _buildTierCard(
              title: 'Prueba Gratuita',
              properties: 'Hasta 10 propiedades',
              price: 'GRATIS',
              isHighlight: true,
              description:
                  'Ideal para conocer la plataforma y registrar tus primeras unidades. Disfruta de todas las herramientas sin presiones.',
              // Updated to reflect no subscription and no card
              footerItems: [
                {'icon': Icons.credit_card_off_rounded, 'text': 'Sin tarjeta de crédito'},
                {'icon': Icons.sync_disabled_rounded, 'text': 'Sin suscripción forzosa'},
              ],
            ),
            const SizedBox(height: 16),

            PrimaryCtaButton(label: 'Comenzar ahora', onPressed: () => Go.to(OnboardingUserRegistrationPage())),
            const SizedBox(height: 16),

            // 3. Paid Tiers
            const Divider(height: 40),
            Text(
              'Planes de Crecimiento',
              style: GoogleFonts.raleway(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF1A4644)),
            ),
            const SizedBox(height: 16),

            _buildTierCard(title: 'Plan Estándar', properties: 'Hasta 100 propiedades', price: '\$599 MXN / mes'),
            const SizedBox(height: 12),
            _buildTierCard(title: 'Plan Profesional', properties: 'Hasta 200 propiedades', price: '\$999 MXN / mes'),
            const SizedBox(height: 24),

            // 4. Contact Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  Text(
                    '¿Necesitas más de 200 propiedades?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  _buildContactLink(Icons.email_outlined, 'ventas@resipal.app'),
                  const SizedBox(height: 8),
                  _buildContactLink(Icons.chat_bubble_outline_rounded, '+52 XX XXXX XXXX'),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // 5. Action Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A4644),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () => Go.to(OnboardingUserRegistrationPage()),
                child: Text(
                  'Comenzar ahora',
                  style: GoogleFonts.raleway(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTierCard({
    required String title,
    required String properties,
    required String price,
    String? description,
    List<Map<String, dynamic>>? footerItems, // Changed to a list for multiple badges
    bool isHighlight = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isHighlight ? const Color(0xFF1A4644).withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isHighlight ? const Color(0xFF1A4644) : Colors.grey.shade300,
          width: isHighlight ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: GoogleFonts.raleway(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(
                price,
                style: GoogleFonts.raleway(fontWeight: FontWeight.w900, color: const Color(0xFF1A4644)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(properties, style: GoogleFonts.raleway(color: Colors.grey.shade700)),

          if (description != null) ...[
            const SizedBox(height: 12),
            Text(description, style: GoogleFonts.raleway(fontSize: 13, color: Colors.grey.shade600, height: 1.4)),
          ],

          if (footerItems != null) ...[
            const SizedBox(height: 16),
            Wrap(
              // Use Wrap in case the screen is narrow
              spacing: 16,
              runSpacing: 8,
              children: footerItems
                  .map(
                    (item) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(item['icon'] as IconData, size: 16, color: const Color(0xFF1A4644)),
                        const SizedBox(width: 6),
                        Text(
                          item['text'] as String,
                          style: GoogleFonts.raleway(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1A4644),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContactLink(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF1A4644)),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.raleway(color: const Color(0xFF1A4644), fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
