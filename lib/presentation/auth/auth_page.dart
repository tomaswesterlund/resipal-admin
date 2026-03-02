import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resipal_admin/presentation/auth/auth_cubit.dart';
import 'package:resipal_admin/presentation/auth/auth_state.dart';
import 'package:resipal_admin/presentation/home/home_page/admin_home_page.dart';
import 'package:resipal_admin/presentation/onboarding/community_registration/onboarding_community_registration_page.dart';
import 'package:resipal_admin/presentation/onboarding/onboarding_start_page.dart';
import 'package:resipal_admin/presentation/shared/resipal_logo.dart';
import 'package:resipal_admin/presentation/signin/signin_page.dart';
import 'package:short_navigation/short_navigation.dart';
import 'package:wester_kit/lib.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: BlocProvider<AuthCubit>(
        create: (ctx) => AuthCubit()..initialize(),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (ctx, state) {
            if (state is UserSignedIn) {
              Go.to(AdminHomePage(community: state.community, user: state.user));
            }
            if (state is UserNotSignedIn) {
              Go.to(const SigninPage());
            }
            if (state is UserNotOnboarded) {
              Go.to(const OnboardingStartPage());
            }
          },
          builder: (ctx, state) {
            if (state is InitialState ||
                state is LoadingState ||
                state is UserSignedIn ||
                state is UserNotSignedIn ||
                state is UserNotOnboarded) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const ResipalLogo(),
                    HeaderText.giga('RESIPAL', color: colorScheme.primary),
                    const SizedBox(height: 24),
                    const LoadingView(
                      title: 'Iniciando Panel de Control',
                      description: 'Verificando credenciales de administrador...',
                    ),
                  ],
                ),
              );
            }

            if (state is UserIsNotAdmin) return const AccessDeniedView();
            if (state is UserHasNoAdminMembership) return const _UserHasNoAdminMembership();
            if (state is ErrorState) return const ErrorView();

            return const UnknownStateView();
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: colorScheme.secondary.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(Icons.domain_add_rounded, size: 64, color: colorScheme.secondary),
          ),
          const SizedBox(height: 32),

          HeaderText.four('Sin comunidad asignada', textAlign: TextAlign.center, color: colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            'Tu perfil está listo, pero aún no administras ninguna comunidad. Puedes crear una nueva ahora mismo o esperar a ser invitado a una existente.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.outline, height: 1.5),
          ),
          const SizedBox(height: 48),

          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              label: 'Crear una Comunidad',
              onPressed: () => Go.to(const OnboardingCommunityRegistrationPage()),
            ),
          ),

          const SizedBox(height: 48),

          // Support Section
          Column(
            children: [
              Text(
                '¿Necesitas ayuda con el acceso?',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.outline.withOpacity(0.7),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SupportIcon(
                    icon: Icons.chat_bubble_outline_rounded,
                    label: 'WhatsApp',
                    onTap: () {}, // Implement WhatsApp launch
                  ),
                  const SizedBox(width: 56),
                  _SupportIcon(
                    icon: Icons.email_outlined,
                    label: 'Correo',
                    onTap: () {}, // Implement Mail launch
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

class _SupportIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SupportIcon({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        children: [
          Icon(icon, color: colorScheme.primary, size: 28),
          const SizedBox(height: 6),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: colorScheme.primary,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
