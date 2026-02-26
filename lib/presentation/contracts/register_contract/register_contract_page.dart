import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resipal_admin/presentation/shared/colors/app_colors.dart';
import 'package:wester_kit/lib.dart';
import 'register_contract_cubit.dart';
import 'register_contract_state.dart';
import 'register_contract_form_state.dart';

class RegisterContractPage extends StatelessWidget {
  const RegisterContractPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: 'Nuevo Contrato'),
      backgroundColor: AppColors.background,
      body: BlocProvider(
        create: (context) => RegisterContractCubit(),
        child: BlocConsumer<RegisterContractCubit, RegisterContractState>(
          listener: (context, state) {
            if (state is FormSubmittedSuccessfullyState) {
              // Option to pop back after success
            }
          },
          builder: (context, state) {
            if (state is FormSubmittingState) return const LoadingView(title: 'Creando contrato...');
            if (state is ErrorState) return ErrorView();
            if (state is FormSubmittedSuccessfullyState) {
              return SuccessView(
                title: '¡Contrato Creado!',
                subtitle: 'Ahora puedes asignar este contrato a las propiedades de tu comunidad.',
                actionButtonLabel: 'VOLVER',
                onActionButtonPressed: () => Navigator.of(context).pop(),
              );
            }
            if (state is FormEditingState) return _ContractForm(state.formState);

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _ContractForm extends StatelessWidget {
  final RegisterContractFormState formState;
  const _ContractForm(this.formState);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterContractCubit>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextInputField(
            label: 'Nombre del Contrato',
            hint: 'Ej: Cuota de Mantenimiento',
            isRequired: true,
            helpText: 'Define el nombre que los residentes verán en sus estados de cuenta.',
            onChanged: cubit.updateName,
          ),
          const SizedBox(height: 24),
          TextInputField(
            label: 'Monto Mensual',
            hint: '0.00',
            isRequired: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            prefixIcon: const Icon(Icons.attach_money),
            helpText: 'Establece el cargo fijo mensual para este contrato.',
            onChanged: cubit.updateAmount,
          ),
          const SizedBox(height: 24),
          TextInputField(
            label: 'Periodicidad',
            hint: 'Selecciona la frecuencia',
            initialValue: formState.period,
            readOnly: true, // As requested
            helpText: 'Por el momento, todos los contratos son de facturación mensual.',
            onChanged: (_) {},
          ),
          const SizedBox(height: 24),
          TextInputField(
            label: 'Descripción (Opcional)',
            hint: 'Detalles sobre lo que incluye este contrato...',
            maxLines: 3,
            onChanged: cubit.updateDescription,
          ),
          const SizedBox(height: 48),
          PrimaryButton(label: 'CREAR CONTRATO', canSubmit: formState.canSubmit, onPressed: () => cubit.submit()),
        ],
      ),
    );
  }
}
