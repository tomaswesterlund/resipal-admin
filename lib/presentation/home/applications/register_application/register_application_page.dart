import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resipal_admin/presentation/home/applications/register_application/registar_application_cubit.dart';
import 'package:wester_kit/lib.dart';
import 'register_application_state.dart';
import 'register_application_form_state.dart';

class RegisterApplicationPage extends StatelessWidget {
  const RegisterApplicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const MyAppBar(title: 'Nueva Solicitud'),
      backgroundColor: colorScheme.background,
      body: BlocProvider(
        create: (context) => RegisterApplicationCubit()..initialize(),
        child: BlocBuilder<RegisterApplicationCubit, RegisterApplicationState>(
          builder: (context, state) {
            if (state is FormSubmittingState) {
              return const LoadingView(title: 'Enviando solicitud...');
            }

            if (state is ErrorState) return const ErrorView();

            if (state is FormSubmittedSuccessfullyState) {
              return SuccessView(
                title: '¡Solicitud Enviada!',
                subtitle: 'La solicitud ha sido registrada y está pendiente de revisión.',
                actionButtonLabel: 'Volver',
                onActionButtonPressed: () => Navigator.of(context).pop(),
              );
            }

            if (state is FormEditingState) {
              return _Form(state.formState);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _Form extends StatelessWidget {
  final RegisterApplicationFormState formState;
  const _Form(this.formState);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterApplicationCubit>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextInputField(
            label: 'Nombre completo',
            hint: 'Ej: Juan Pérez',
            isRequired: true,
            onChanged: cubit.updateName,
          ),
          const SizedBox(height: 20),
          EmailInputField(label: 'Correo electrónico', isRequired: true, onChanged: cubit.updateEmail),
          const SizedBox(height: 20),
          PhoneNumberInputField(
            label: 'Teléfono de contacto',
            isRequired: true,
            helpText: 'Tu número principal para recibir notificaciones.',
            onChanged: cubit.updatePhone,
          ),
          const SizedBox(height: 20),
          PhoneNumberInputField(
            label: 'Teléfono de emergencia',
            isRequired: false,
            helpText: 'Número de un contacto de confianza en caso de incidentes dentro de la comunidad.',
            onChanged: cubit.updatePhone,
          ),

          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: InputLabel(
              label: 'Roles solicitados',
              isRequired: true,
              helpText:
                  'Define los permisos que tendrá el usuario. Puedes seleccionar varios roles dependiendo de sus responsabilidades en la comunidad.',
            ),
          ),
          DefaultCard(
            child: Column(
              children: [
                CheckboxListTile(
                  title: const Text('Residente'),
                  value: formState.isResident,
                  onChanged: cubit.toggleResident,
                ),
                CheckboxListTile(
                  title: const Text('Administrador'),
                  value: formState.isAdmin,
                  onChanged: cubit.toggleAdmin,
                ),
                CheckboxListTile(
                  title: const Text('Seguridad'),
                  value: formState.isSecurity,
                  onChanged: cubit.toggleSecurity,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
          TextInputField(
            label: 'Mensaje de invitación',
            hint: 'Ej: Hola, te invitamos a unirte a nuestra comunidad. Por favor completa tu registro.',
            maxLines: 3,
            isRequired: true,
            helpText:
                'Este mensaje se enviará al usuario junto con su invitación para darle contexto sobre el acceso a la comunidad.',
            onChanged: cubit.updateMessage,
          ),

          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(label: 'ENVIAR SOLICITUD', canSubmit: formState.canSubmit, onPressed: cubit.submit),
          ),
        ],
      ),
    );
  }
}
