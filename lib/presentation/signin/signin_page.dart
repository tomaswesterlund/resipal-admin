import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resipal_admin/presentation/auth/auth_page.dart';
import 'package:resipal_admin/presentation/home/admin_home_page.dart';
import 'package:resipal_admin/presentation/signin/signin_cubit.dart';
import 'package:resipal_admin/presentation/signin/signin_state.dart';
import 'package:resipal_core/presentation/shared/buttons/social_login_button.dart';
import 'package:resipal_core/presentation/shared/colors/base_app_colors.dart';
import 'package:resipal_core/presentation/shared/containers/green_box_container.dart';
import 'package:resipal_core/presentation/shared/resipal_logo.dart';
import 'package:resipal_core/presentation/shared/texts/header_text.dart';
import 'package:resipal_core/presentation/shared/views/error_view.dart';
import 'package:resipal_core/presentation/shared/views/loading_view.dart';
import 'package:resipal_core/presentation/shared/views/unknown_state_view.dart';
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
            if (state is AdminSignedInSuccessfullyState) {
              Go.to(AuthPage());
            }
          },
          builder: (context, state) {
            if (state is InitialState) {
              return _Signin();
            }

            if (state is AdminSigningInState || state is AdminSignedInSuccessfullyState) {
              return LoadingView(title: 'Iniciando sesión', description: 'Estamos configurando tu espacio...');
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

class _Signin extends StatelessWidget {
  const _Signin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaseAppColors.background,
      body: Column(
        children: [
          // --- Brand Header ---
          GreenBoxContainer(
            child: SafeArea(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 0.0),
                child: Column(
                  children: [
                    ResipalLogo(),
                    const SizedBox(height: 16),
                    HeaderText.giga('Resipal Admin', color: Colors.white), // Added "Admin"
                    const Text(
                      'Gestión y Administración',
                      style: TextStyle(color: Colors.white70, fontSize: 14, letterSpacing: 0.5),
                    ), // Changed from "Bienvenido a tu hogar"
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
                HeaderText.four(
                  'Panel de Administración',
                  color: BaseAppColors.secondary,
                ), // Changed from "Bienvenido de nuevo"
                const SizedBox(height: 8),
                const Text(
                  'Inicia sesión para gestionar el complejo residencial', // Refined for Admin clarity
                  textAlign: TextAlign.center,
                  style: TextStyle(color: BaseAppColors.hintText),
                ),
                const SizedBox(height: 24),

                // Google Sign In
                SocialLoginButton(
                  label: 'Continuar con Google',
                  icon: Icons.g_mobiledata_rounded,
                  backgroundColor: Colors.white,
                  textColor: Colors.black87,
                  onPressed: () => context.read<SigninCubit>().signin(),
                ),

                const SizedBox(height: 16),

                // Apple Sign In
                SocialLoginButton(
                  label: 'Continuar con Apple',
                  icon: Icons.apple,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  onPressed: () {
                    // TODO: Implement Apple Sign In
                  },
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
          const Spacer(),
          const SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                'Acceso exclusivo para administradores autorizados',
                style: TextStyle(fontSize: 10, color: BaseAppColors.hintText),
              ), // Added a subtle security/role reminder
            ),
          ),
        ],
      ),
    );
  }
}
