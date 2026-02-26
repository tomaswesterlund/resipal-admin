import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resipal_admin/presentation/auth/auth_cubit.dart';
import 'package:resipal_admin/presentation/auth/auth_state.dart';
import 'package:resipal_admin/presentation/home/admin_home_page.dart';
import 'package:resipal_admin/presentation/onboarding/community_registration/onboarding_community_registration_page.dart';
import 'package:resipal_admin/presentation/onboarding/onboarding_start_page.dart';
import 'package:resipal_admin/presentation/signin/signin_page.dart';
import 'package:resipal_admin/shared/views/access_denied_view.dart';
import 'package:resipal_admin/shared/views/error_view.dart';
import 'package:resipal_admin/shared/views/loading_view.dart';
import 'package:resipal_core/presentation/shared/colors/base_app_colors.dart';
import 'package:resipal_core/presentation/shared/texts/header_text.dart';
import 'package:resipal_core/presentation/shared/views/unknown_state_view.dart';
import 'package:short_navigation/short_navigation.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<AuthCubit>(
        create: (ctx) => AuthCubit()..initialize(),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (ctx, state) {
            if (state is UserSignedIn) {
              Go.to(AdminHomePage(community: state.community, user: state.user));
            }

            if (state is UserNotSignedIn) {
              Go.to(SigninPage());
            }

            if (state is UserNotOnboarded) {
              Go.to(OnboardingStartPage());
            }
          },
          builder: (ctx, state) {
            if (state is InitialState ||
                state is LoadingState ||
                state is UserSignedIn ||
                state is UserNotSignedIn ||
                state is UserNotOnboarded) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HeaderText.giga('RESIPAL'),
                  const SizedBox(height: 24),
                  LoadingView(
                    title: 'Iniciando Panel de Control',
                    description: 'Verificando credenciales de administrador...',
                  ),
                ],
              );
            }

            if (state is UserIsNotAdmin) {
              return AccessDeniedView();
            }

            if (state is UserHasNoAdminMembership) {
              return _UserHasNoAdminMembership();
            }

            if (state is ErrorState) {
              return ErrorView();
            }

            return UnknownStateView();
          },
        ),
      ),
    );
  }
}

class _UserHasNoAdminMembership extends StatelessWidget {
  const _UserHasNoAdminMembership();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 1. Visual Icon
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: BaseAppColors.secondary.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(Icons.domain_add_rounded, size: 64, color: BaseAppColors.secondary),
          ),
          const SizedBox(height: 32),

          // 2. Messaging
          HeaderText.four('Sin comunidad asignada', textAlign: TextAlign.center, color: const Color(0xFF1A4644)),
          const SizedBox(height: 16),
          Text(
            'Tu perfil está listo, pero aún no administras ninguna comunidad. Puedes crear una nueva ahora mismo o esperar a ser invitado a una existente.',
            textAlign: TextAlign.center,
            style: GoogleFonts.raleway(fontSize: 15, color: Colors.grey.shade600, height: 1.5),
          ),
          const SizedBox(height: 48),

          // 3. Primary Action: Create Community
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A4644),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () => Go.to(const OnboardingCommunityRegistrationPage()),
              child: Text(
                'Crear una Comunidad',
                style: GoogleFonts.raleway(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),

          const SizedBox(height: 48),

          // 4. Support Section
          Column(
            children: [
              Text(
                '¿Necesitas ayuda con el acceso?',
                style: GoogleFonts.raleway(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade400),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SupportIcon(
                    icon: Icons.chat_bubble_outline_rounded,
                    label: 'WhatsApp',
                    onTap: () {
                      // TODO: Implement url_launcher to wa.me/
                    },
                  ),
                  const SizedBox(width: 40),
                  _SupportIcon(
                    icon: Icons.email_outlined,
                    label: 'Correo',
                    onTap: () {
                      // TODO: Implement url_launcher to mailto:
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ... elsewhere in your file or as a private widget helper:

class _SupportIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SupportIcon({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF1A4644), size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.raleway(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF1A4644)),
          ),
        ],
      ),
    );
  }
}
