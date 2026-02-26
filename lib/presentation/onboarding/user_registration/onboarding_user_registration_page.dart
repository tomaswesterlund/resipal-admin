import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resipal_admin/presentation/shared/colors/app_colors.dart';
import 'package:resipal_admin/presentation/onboarding/community_registration/onboarding_community_registration_page.dart';
import 'package:resipal_admin/presentation/onboarding/user_registration/onboarding_user_registration_cubit.dart';
import 'package:resipal_admin/presentation/onboarding/user_registration/onboarding_user_registration_state.dart';
import 'package:wester_kit/lib.dart';
import 'package:short_navigation/short_navigation.dart';

class OnboardingUserRegistrationPage extends StatelessWidget {
  const OnboardingUserRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingUserRegistrationCubit()..initialize(),
      child: BlocListener<OnboardingUserRegistrationCubit, OnboardingUserRegistrationState>(
        listener: (context, state) {},
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: const MyAppBar(title: 'Perfil de Administrador', automaticallyImplyLeading: false),
          body: BlocBuilder<OnboardingUserRegistrationCubit, OnboardingUserRegistrationState>(
            builder: (context, state) {
              if (state is InitialState || state is FormSubmittingState) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is FormSubmittingState) {
                return const LoadingView(
                  title: 'Finalizando tu registro',
                  description: 'Estamos configurando tu cuenta de administrador y preparando tu panel de control.',
                );
              }

              if (state is FormSubmittedSuccessfully) {
                return SuccessView(
                  title: '¡Perfil creado!',
                  subtitle:
                      'Tu información de administrador se ha guardado correctamente. Ahora, vamos a registrar tu comunidad para empezar a gestionar.',
                  actionButtonLabel: 'Registrar mi Comunidad',
                  onActionButtonPressed: () {
                    Go.to(const OnboardingCommunityRegistrationPage());
                  },
                );
              }

              if (state is ErrorState) {
                return ErrorView();
              }

              if (state is FormEditingState) {
                final form = state.formstate;
                final cubit = context.read<OnboardingUserRegistrationCubit>();

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderText.five('Completa tu perfil', color: const Color(0xFF1A4644)),
                      const SizedBox(height: 8),
                      Text(
                        'Estos datos se utilizarán para que los residentes puedan contactarte y para generar tus reportes.',
                        style: GoogleFonts.raleway(fontSize: 14, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 32),

                      TextInputField(
                        label: 'Nombre completo',
                        hint: 'Ej: Juan Pérez',
                        isRequired: true,
                        initialValue: form.name,
                        helpText: 'Tu nombre real como administrador.',
                        onChanged: cubit.onNameChanged,
                      ),
                      const SizedBox(height: 20),

                      PhoneNumberInputField(
                        label: 'Teléfono de contacto',
                        hint: 'XX XXXX XXXX',
                        isRequired: true,
                        initialValue: form.phoneNumber,
                        onChanged: cubit.onPhoneChanged,
                      ),
                      const SizedBox(height: 20),

                      _ReadOnlyEmailField(email: form.email),

                      const SizedBox(height: 48),
                      PrimaryButton(
                        label: 'Finalizar Registro',
                        onPressed: form.canSubmit ? () => cubit.submit() : null,
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

class _ReadOnlyEmailField extends StatelessWidget {
  final String email;
  const _ReadOnlyEmailField({required this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            'Correo Electrónico',
            style: GoogleFonts.raleway(fontSize: 14.0, fontWeight: FontWeight.w600, color: const Color(0xFF1A4644)),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(email, style: GoogleFonts.raleway(fontSize: 16.0, color: Colors.grey.shade600)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 4.0),
          child: Text(
            'El correo está vinculado a tu cuenta.',
            style: GoogleFonts.raleway(fontSize: 11, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
