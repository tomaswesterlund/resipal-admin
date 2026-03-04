import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resipal_admin/presentation/onboarding/community_registration/onboarding_community_registration_page.dart';
import 'package:resipal_admin/presentation/onboarding/user_registration/onboarding_user_registration_cubit.dart';
import 'package:resipal_admin/presentation/onboarding/user_registration/onboarding_user_registration_state.dart';
import 'package:wester_kit/lib.dart';
import 'package:short_navigation/short_navigation.dart';

class OnboardingUserRegistrationPage extends StatelessWidget {
  const OnboardingUserRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocProvider(
      create: (context) => OnboardingUserRegistrationCubit()..initialize(),
      child: BlocListener<OnboardingUserRegistrationCubit, OnboardingUserRegistrationState>(
        listener: (context, state) {},
        child: Scaffold(
          backgroundColor: colorScheme.background,
          appBar: const MyAppBar(title: 'Perfil de Administrador', automaticallyImplyLeading: false),
          body: BlocBuilder<OnboardingUserRegistrationCubit, OnboardingUserRegistrationState>(
            builder: (context, state) {
              if (state is InitialState) {
                return Center(child: CircularProgressIndicator(color: colorScheme.primary));
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
                return const ErrorView();
              }

              if (state is FormEditingState) {
                final form = state.formstate;
                final cubit = context.read<OnboardingUserRegistrationCubit>();

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderText.five('Completa tu perfil', color: colorScheme.primary),
                      const SizedBox(height: 8),
                      Text(
                        'Estos datos se utilizarán para que los residentes puedan contactarte y para generar tus reportes.',
                        style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.inverseSurface),
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
                        helpText: 'Tu número principal para recibir notificaciones y contacto directo de la administración.',
                        onChanged: cubit.onPhoneChanged,
                      ),
                      const SizedBox(height: 20),

                      TextInputField(
                        label: 'Teléfono de emergencia',
                        hint: 'Ej: 55 8765 4321',
                        isRequired: false,
                        keyboardType: TextInputType.phone,
                        helpText: 'Número de un contacto de confianza en caso de incidentes dentro de la comunidad.',
                        onChanged: cubit.onEmergencyPhoneChanged,
                      ),
                      const SizedBox(height: 20.0),

                      EmailInputField(
                        label: 'Correo electrónicio',
                        isRequired: true,
                        readOnly: true,
                        initialValue: form.email,
                      ),

                      const SizedBox(height: 48),
                      SizedBox(
                        width: double.infinity,
                        child: PrimaryButton(
                          label: 'Finalizar Registro',
                          onPressed: form.canSubmit ? () => cubit.submit() : null,
                        ),
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
