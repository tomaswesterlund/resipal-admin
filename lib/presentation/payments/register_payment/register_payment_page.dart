import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resipal_admin/presentation/shared/colors/app_colors.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';
import 'register_payment_cubit.dart';
import 'register_payment_state.dart';
import 'register_payment_form_state.dart';

class RegisterPaymentPage extends StatelessWidget {
  const RegisterPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: 'Registrar Pago'),
      body: BlocProvider(
        create: (context) => RegisterPaymentCubit()..initialize(),
        child: BlocConsumer<RegisterPaymentCubit, RegisterPaymentState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is NoResidentsFound) {
              return const _NoResidentsFound();
            }

            if (state is FormSubmittingState) {
              return const LoadingView(title: 'Procesando pago...');
            }

            if (state is ErrorState) {
              return ErrorView();
            }

            if (state is FormSubmittedSuccessfullyState) {
              return SuccessView(
                title: '¡Pago Registrado!',
                subtitle: 'El saldo del residente ha sido actualizado correctamente.',
                actionButtonLabel: 'VOLVER',
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
            ImagePreview(imageUrl: formState.receiptImage!.path)
          else
            ImagePickerButtons(
              onCamera: () => cubit.pickImage(ImageSource.camera),
              onGallery: () => cubit.pickImage(ImageSource.gallery),
            ),
          const SizedBox(height: 48),
          PrimaryButton(label: 'REGISTRAR PAGO', canSubmit: formState.canSubmit, onPressed: () => cubit.submit()),
        ],
      ),
    );
  }
}

class _NoResidentsFound extends StatelessWidget {
  const _NoResidentsFound();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Visual indicator for missing residents
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: AppColors.secondary.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(Icons.person_add_disabled_outlined, size: 64, color: AppColors.secondary),
          ),
          const SizedBox(height: 32),

          HeaderText.four('No hay residentes registrados', textAlign: TextAlign.center, color: const Color(0xFF1A4644)),
          const SizedBox(height: 16),

          Text(
            'No puedes registrar un pago si no hay residentes en el sistema. Primero debes dar de alta a los usuarios y asignarles una propiedad.',
            textAlign: TextAlign.center,
            style: GoogleFonts.raleway(fontSize: 15, color: Colors.grey.shade600, height: 1.5),
          ),
          const SizedBox(height: 48),

          // Action to fix the missing requirement
          PrimaryButton(
            label: 'IR AL DIRECTORIO',
            canSubmit: true,
            onPressed: () {
              // TODO: Navigate to Residents Directory or Register Resident
              // Go.to(const RegisterResidentPage());
            },
          ),

          const SizedBox(height: 20),

          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Volver',
              style: GoogleFonts.raleway(color: Colors.grey.shade500, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
