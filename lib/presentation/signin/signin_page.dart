import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resipal_admin/presentation/auth/auth_gate.dart';
import 'package:resipal_admin/presentation/home/home_page/admin_home_page.dart';
import 'package:resipal_admin/presentation/shared/resipal_logo.dart';
import 'package:resipal_admin/presentation/signin/signin_cubit.dart';
import 'package:resipal_admin/presentation/signin/signin_state.dart';
import 'package:wester_kit/lib.dart';
import 'package:short_navigation/short_navigation.dart';

class SigninPage extends StatelessWidget {
  const SigninPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<SigninCubit>(
        create: (ctx) => SigninCubit(),
        child: BlocConsumer<SigninCubit, SigninState>(
          listener: (context, state) {
            // if (state is AdminSignedInSuccessfullyState) {
            //   Go.to(const AdminHomePage());
            // }
          },
          builder: (context, state) {
            if (state is InitialState) {
              return const _Signin();
            }

            if (state is AdminSigningInState || state is AdminSignedInSuccessfullyState) {
              return const LoadingView(
                logo: ResipalLogo(),
                title: 'Iniciando sesión',
                description: 'Estamos configurando tu espacio...',
              );
            }

            if (state is ErrorState) {
              return const ErrorView();
            }

            return const UnknownStateView();
          },
        ),
      ),
    );
  }
}

class _Signin extends StatelessWidget {
  const _Signin();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Column(
        children: [
          // --- Brand Header ---
          Container(
            padding: const EdgeInsets.all(30),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorScheme.primaryContainer.withOpacity(0.4), // Soft brand start
                  colorScheme.background, // Fades into page color
                ],
              ),
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const ResipalLogo(),
                    const SizedBox(height: 16),
                    HeaderText.giga('Resipal Admin', color: colorScheme.onBackground, textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    Text(
                      'Gestión y Administración',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onBackground.withOpacity(0.7),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // --- Login Actions ---
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                HeaderText.four('Panel de Administración', color: colorScheme.onBackground),
                const SizedBox(height: 8),
                Text(
                  'Inicia sesión para gestionar el complejo residencial',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
                ),
                const SizedBox(height: 32),

                // Google Sign In
                SocialLoginButton(
                  label: 'Continuar con Google',
                  icon: Icons.g_mobiledata_rounded,
                  backgroundColor: colorScheme.surface,
                  textColor: colorScheme.onSurface,
                  onPressed: () => context.read<SigninCubit>().signin(),
                ),

                const SizedBox(height: 16),

                // Apple Sign In
                SocialLoginButton(
                  label: 'Continuar con Apple',
                  icon: Icons.apple,
                  backgroundColor: Colors.black, // Apple branding usually stays black
                  textColor: Colors.white,
                  onPressed: () {
                    // TODO: Implement Apple Sign In
                  },
                ),
              ],
            ),
          ),
          const Spacer(),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                'Acceso exclusivo para administradores autorizados',
                style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.outline, fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
