import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resipal_admin/presentation/home/home_page/admin_home_page.dart';
import 'package:resipal_admin/presentation/onboarding/community_registration/onboarding_community_registration_cubit.dart';
import 'package:resipal_admin/presentation/onboarding/community_registration/onboarding_community_registration_state.dart';
import 'package:wester_kit/lib.dart';
import 'package:short_navigation/short_navigation.dart';

class OnboardingCommunityRegistrationPage extends StatelessWidget {
  const OnboardingCommunityRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocProvider(
      create: (context) => OnboardingCommunityRegistrationCubit()..initialize(),
      child: Scaffold(
        // Pulls from your mapped AppColors.background
        backgroundColor: colorScheme.background,
        appBar: const MyAppBar(title: 'Nueva Comunidad', automaticallyImplyLeading: false),
        body: BlocBuilder<OnboardingCommunityRegistrationCubit, OnboardingCommunityRegistrationState>(
          builder: (context, state) {
            if (state is FormSubmittingState) {
              return const LoadingView(
                title: 'Creando tu comunidad',
                description: 'Estamos configurando el espacio digital para tus residentes.',
              );
            }

            if (state is FormSubmittedSuccessfully) {
              return SuccessView(
                title: '¡Comunidad Creada!',
                subtitle: 'El registro ha sido exitoso. Ahora puedes empezar a registrar propiedades y pagos.',
                actionButtonLabel: 'Continuar',
                onActionButtonPressed: () {
                  Go.to(AdminHomePage(community: state.community, user: state.user));
                },
              );
            }

            if (state is ErrorState) return const ErrorView();

            if (state is FormEditingState) {
              final form = state.formstate;
              final cubit = context.read<OnboardingCommunityRegistrationCubit>();

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Uses Primary Green from Theme
                    HeaderText.five('Datos de la Comunidad', color: colorScheme.primary),
                    const SizedBox(height: 8),
                    Text(
                      'Define el nombre y la ubicación de la comunidad que vas a administrar.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.outline, // Replaces Colors.grey.shade600
                      ),
                    ),
                    const SizedBox(height: 32),

                    TextInputField(
                      label: 'Nombre de la Comunidad',
                      hint: 'Ej: Residencial Los Olivos',
                      isRequired: true,
                      initialValue: form.name,
                      onChanged: cubit.onNameChanged,
                    ),
                    const SizedBox(height: 20),

                    TextInputField(
                      label: 'Ubicación',
                      hint: 'Calle, número, colonia...',
                      isRequired: true,
                      initialValue: form.address,
                      onChanged: cubit.onAddressChanged,
                    ),
                    const SizedBox(height: 20),

                    TextInputField(
                      label: 'Descripción (Opcional)',
                      hint: 'Breve descripción o mensaje de bienvenida...',
                      maxLines: 3,
                      initialValue: form.location,
                      onChanged: cubit.onDescriptionChanged,
                    ),

                    const SizedBox(height: 48),

                    // Primary Button - Linked to Theme
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          disabledBackgroundColor: colorScheme.outlineVariant,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        onPressed: form.canSubmit ? () => cubit.submit() : null,
                        child: Text(
                          'Crear Comunidad',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: form.canSubmit ? colorScheme.onPrimary : colorScheme.outline,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Center(child: CircularProgressIndicator(color: colorScheme.primary));
          },
        ),
      ),
    );
  }
}
