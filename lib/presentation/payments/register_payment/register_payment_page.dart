import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';
import 'register_payment_cubit.dart';
import 'register_payment_state.dart';
import 'register_payment_form_state.dart';

class RegisterPaymentPage extends StatelessWidget {
  const RegisterPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const MyAppBar(title: 'Registrar Pago'),
      backgroundColor: colorScheme.background,
      body: BlocProvider(
        create: (context) => RegisterPaymentCubit()..initialize(),
        child: BlocConsumer<RegisterPaymentCubit, RegisterPaymentState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is NoResidentsFound) return const _NoResidentsFound();

            if (state is FormSubmittingState) {
              return const LoadingView(title: 'Procesando pago...');
            }

            if (state is ErrorState) return const ErrorView();

            if (state is FormSubmittedSuccessfullyState) {
              return SuccessView(
                title: '¡Pago Registrado!',
                subtitle: 'El saldo del residente ha sido actualizado correctamente.',
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
  final RegisterPaymentFormState formState;
  const _Form(this.formState);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterPaymentCubit>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          EntityDropdownField<ResidentEntity>(
            label: 'Residente',
            isRequired: true,
            helpText: 'Selecciona el residente que hizo este pago.',
            itemLabelBuilder: (resident) => resident.user.name,
            items: formState.residents,
            onChanged: cubit.updateResident,
          ),

          const SizedBox(height: 24),
          AmountInputField(label: 'Monto', isRequired: true, onChanged: cubit.updateAmount),

          const SizedBox(height: 24),
          DatePickerField(
            label: 'Fecha de pago',
            isRequired: true,
            helpText: 'Selecciona la fecha exacta de la transferencia o depósito.',
            selectedDate: formState.payDate,
            onDateChanged: cubit.updatePayDate,
          ),

          const SizedBox(height: 24),
          TextInputField(
            label: 'Referencia / No. de Operación',
            hint: 'Ej: TRANS-12345',
            isRequired: true,
            onChanged: cubit.updateReference,
          ),

          const SizedBox(height: 24),
          TextInputField(
            label: 'Nota Interna',
            hint: 'Ej: Pago adelantado de marzo',
            maxLines: 2,
            onChanged: cubit.updateNote,
          ),

          const SizedBox(height: 24),

          if (formState.receiptImage != null)
            XFileImagePreview(
              xFile: formState.receiptImage!,
              //onDelete: () => cubit.removeImage(), // Assuming removeImage exists
            )
          else
            ImagePickerButtons(
              onCamera: () => cubit.pickImage(ImageSource.camera),
              onGallery: () => cubit.pickImage(ImageSource.gallery),
            ),

          const SizedBox(height: 48),

          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              label: 'REGISTRAR PAGO',
              canSubmit: formState.canSubmit,
              onPressed: () => cubit.submit(),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoResidentsFound extends StatelessWidget {
  const _NoResidentsFound();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: colorScheme.primary.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(Icons.groups_outlined, size: 64, color: colorScheme.primary),
            ),
            const SizedBox(height: 32),
            HeaderText.four('No hay residentes registrados', textAlign: TextAlign.center, color: colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'No puedes registrar un pago si no hay residentes en el sistema. Primero debes dar de alta a los usuarios y asignarles una propiedad.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.inverseSurface),
            ),
            const SizedBox(height: 32),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Registrar residente'),
              style: TextButton.styleFrom(foregroundColor: colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}
