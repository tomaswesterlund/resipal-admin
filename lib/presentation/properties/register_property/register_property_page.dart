import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resipal_admin/presentation/contracts/register_contract/register_contract_page.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';
import 'package:short_navigation/short_navigation.dart';
import 'register_property_cubit.dart';
import 'register_property_form_state.dart';
import 'register_property_state.dart';

class RegisterPropertyPage extends StatelessWidget {
  const RegisterPropertyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const MyAppBar(title: 'Registrar una propiedad'),
      backgroundColor: colorScheme.background,
      body: BlocProvider<RegisterPropertyCubit>(
        create: (ctx) => RegisterPropertyCubit()..initialize(),
        child: BlocConsumer<RegisterPropertyCubit, RegisterPropertyState>(
          listener: (ctx, state) {},
          builder: (ctx, state) {
            if (state is NoContractsFound) return const _NoContractsFound();
            if (state is FormEditingState) return _Form(state.formState);
            
            if (state is FormSubmittingState) {
              return const LoadingView(title: 'Registrando nueva propiedad ...');
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
  final RegisterPropertyFormState formState;
  const _Form(this.formState);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterPropertyCubit>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextInputField(
            label: 'Nombre',
            hint: 'Ej: Lote o Casa 143',
            isRequired: true,
            helpText: 'Este es el nombre oficial que aparecerá en los reportes y recibos.',
            onChanged: cubit.updateName,
          ),
          const SizedBox(height: 20.0),
          EntityDropdownField<ContractEntity>(
            label: "Seleccionar contrato",
            isRequired: true,
            helpText: "Vincula un contrato legal vigente a este registro...",
            items: formState.contracts,
            value: null,
            itemLabelBuilder: (contract) => contract.name,
            onChanged: (contract) => cubit.onContractSelected(contract),
          ),
          const SizedBox(height: 20.0),
          EntityDropdownField<ResidentEntity>(
            label: "Seleccionar residente",
            isRequired: false,
            helpText: "Busca y selecciona al residente...",
            items: formState.residents,
            value: null,
            itemLabelBuilder: (resident) => resident.user.name,
            onChanged: (resident) => cubit.onResidentSelected(resident),
          ),
          const SizedBox(height: 20.0),
          TextInputField(
            label: 'Descripción',
            hint: 'Breve descripción de la propiedad...',
            isRequired: false,
            helpText: 'Detalles adicionales o notas internas para administración.',
            onChanged: cubit.updateDescription,
          ),
          const SizedBox(height: 32.0),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              label: 'Registrar propiedad',
              canSubmit: formState.canSubmit,
              onPressed: () => cubit.submit(),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoContractsFound extends StatelessWidget {
  const _NoContractsFound();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.secondary.withOpacity(0.1), 
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.description_outlined, size: 64, color: colorScheme.secondary),
          ),
          const SizedBox(height: 32),
          HeaderText.four(
            'No hay contratos activos', 
            textAlign: TextAlign.center, 
            color: colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Para registrar una propiedad, primero necesitas definir al menos un tipo de contrato (ej: Mensualidad, Mantenimiento).',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.outline,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              label: 'Configurar Contratos',
              onPressed: () => Go.to(const RegisterContractPage()),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Volver',
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.outline,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}