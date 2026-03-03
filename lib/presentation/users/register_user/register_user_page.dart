import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resipal_admin/presentation/users/register_user/register_user_cubit.dart';
import 'package:resipal_admin/presentation/users/register_user/register_user_form_state.dart';
import 'package:resipal_admin/presentation/users/register_user/register_user_state.dart';
import 'package:wester_kit/lib.dart';

class RegisterUserPage extends StatelessWidget {
  const RegisterUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const MyAppBar(title: 'Registrar propiedad'),
      backgroundColor: colorScheme.background,
      body: BlocProvider<RegisterUserCubit>(
        create: (ctx) => RegisterUserCubit()..initialize(),
        child: BlocConsumer<RegisterUserCubit, RegisterUserState>(
          listener: (ctx, state) {},
          builder: (ctx, state) {
            if (state is FormEditingState) return _Form(state.formState);

            if (state is FormSubmittingState) {
              return const LoadingView(title: 'Registrando nuevo usuario ...');
            }

            if (state is FormSubmittedSuccessfullyState) {
              return SuccessView(
                title: '¡Propiedad registrada!',
                actionButtonLabel: 'VOLVER',
                onActionButtonPressed: () => Navigator.of(context).pop(),
              );
            }

            if (state is ErrorState) return const ErrorView();

            return const UnknownStateView();
          },
        ),
      ),
    );
  }
}

class _Form extends StatelessWidget {
  final RegisterUserFormState formState;
  const _Form(this.formState);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterUserCubit>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextInputField(
            label: 'Nombre completo',
            hint: 'Ej: Juan Pérez',
            isRequired: true,
            helpText: 'Ingresa el nombre del residente tal como aparecerá en su perfil y comunicados.',
            onChanged: cubit.updateName,
          ),
          const SizedBox(height: 20.0),

          TextInputField(
            label: 'Número de teléfono',
            hint: 'Ej: 55 1234 5678',
            isRequired: true,
            keyboardType: TextInputType.phone,
            helpText: 'Este número se utilizará para el acceso a la aplicación y notificaciones importantes.',
            onChanged: cubit.updatePhoneNumber,
          ),
          const SizedBox(height: 20.0),

          EmailInputField(
            label: 'Correo electrónico',
            hint: 'ejemplo@correo.com',
            isRequired: true,
            helpText:
                'Este correo se utilizará para que el usuario pueda iniciar sesión y recibir comprobantes de pago.',
            onChanged: cubit.updateEmail,
          ),
          const SizedBox(height: 20.0),

          TextInputField(
            label: 'Teléfono de emergencia',
            hint: 'Ej: 55 8765 4321',
            isRequired: false,
            keyboardType: TextInputType.phone,
            helpText: 'Número de un contacto de confianza en caso de incidentes dentro de la comunidad.',
            onChanged: cubit.updateEmergencyPhoneNumber,
          ),
          const SizedBox(height: 20.0),

          InputLabel(
            label: 'Asignación de Roles',
            isRequired: true,
            helpText:
                'Los roles definen qué acciones puede realizar el usuario y a qué módulos tiene acceso. Un usuario puede tener más de un rol asignado simultáneamente (por ejemplo, ser Residente y Administrador).',
          ),
          const SizedBox(height: 20.0),

          CheckboxField(
            label: 'Administrador',
            value: formState.isAdmin,
            helpText: 'Permite gestionar pagos, residentes, propiedades y la configuración total de la comunidad.',
            onChanged: cubit.updateIsAdmin,
          ),
          const SizedBox(height: 8),

          CheckboxField(
            label: 'Residente',
            value: formState.isResident,
            helpText:
                'Otorga acceso a la app móvil para generar invitaciones, ver estados de cuenta y recibir comunicados.',
            onChanged: cubit.updateIsResident,
          ),
          const SizedBox(height: 8),

          CheckboxField(
            label: 'Seguridad',
            value: formState.isSecuriy,
            helpText:
                'Habilita las herramientas de control de acceso para el escaneo de códigos QR y registro de visitas.',
            onChanged: cubit.updateIsSecurity,
          ),

          const SizedBox(height: 32.0),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              label: 'Registrar usuario',
              canSubmit: formState.canSubmit,
              onPressed: () => cubit.submit(),
            ),
          ),
        ],
      ),
    );
  }
}
