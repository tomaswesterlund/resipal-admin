import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resipal_admin/presentation/contracts/register_contract/register_contract_page.dart';
import 'package:resipal_admin/shared/app_colors.dart';
import 'package:resipal_admin/shared/buttons/primary_cta_button.dart';
import 'package:resipal_core/domain/entities/contract_entity.dart';
import 'package:resipal_core/domain/entities/resident_entity.dart';
import 'package:resipal_core/presentation/shared/colors/base_app_colors.dart';
import 'package:short_navigation/short_navigation.dart';
import 'register_property_cubit.dart';
import 'register_property_form_state.dart';
import 'register_property_state.dart';
import 'package:resipal_core/presentation/shared/inputs/entry_dropdown_field.dart';
import 'package:resipal_core/presentation/shared/inputs/text_input_field.dart';
import 'package:resipal_core/presentation/shared/my_app_bar.dart';
import 'package:resipal_core/presentation/shared/texts/header_text.dart';
import 'package:resipal_core/presentation/shared/views/error_view.dart';
import 'package:resipal_core/presentation/shared/views/loading_view.dart';
import 'package:resipal_core/presentation/shared/views/success_view.dart';
import 'package:resipal_core/presentation/shared/views/unknown_state_view.dart';

class RegisterPropertyPage extends StatelessWidget {
  const RegisterPropertyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Registrar una propiedad'),
      backgroundColor: AppColors.background,
      body: BlocProvider<RegisterPropertyCubit>(
        create: (ctx) => RegisterPropertyCubit()..initialize(),
        child: BlocConsumer<RegisterPropertyCubit, RegisterPropertyState>(
          listener: (ctx, state) {
            //if (state is FormSubmittedSuccessfully) {}
          },
          builder: (ctx, state) {
            if (state is NoContractsFound) {
              return _NoContractsFound();
            }

            if (state is FormEditingState) {
              return _Form(state.formState);
            }

            if (state is FormSubmittingState) {
              return LoadingView(title: 'Registrando nueva propiedad ...');
            }

            if (state is FormSubmittedSuccessfullyState) {
              return SuccessView(
                title: '¡Propiedad registrada!',
                // subtitle:
                //     'Tu comprobante está siendo revisado por administración.',
                actionButtonLabel: 'VOLVER',
                onActionButtonPressed: () {
                  Navigator.of(context).pop();
                },
              );
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

class _Form extends StatelessWidget {
  final RegisterPropertyFormState formState;
  const _Form(this.formState, {super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterPropertyCubit>();

    return SingleChildScrollView(
      // Added scroll for smaller screens
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextInputField(
            label: 'Nombre',
            hint: 'Ej: Lote o Casa 143',
            isRequired: true,
            helpText:
                'Este es el nombre oficial que aparecerá en los reportes, recibos de pago y comunicaciones para los residentes.',
            onChanged: cubit.updateName,
          ),
          const SizedBox(height: 20.0),
          EntityDropdownField<ContractEntity>(
            label: "Seleccionar contrato",
            isRequired: true,
            helpText:
                "Vincula un contrato legal vigente a este registro. Este campo es obligatorio para habilitar el seguimiento de pagos y vigencia de la estancia.",
            items: formState.contracts,
            value: null,
            itemLabel: (contract) => contract.name,
            onChanged: (contract) => cubit.onContractSelected(contract),
          ),
          SizedBox(height: 20.0),

          EntityDropdownField<ResidentEntity>(
            label: "Seleccionar residente",
            isRequired: false,
            helpText:
                "Busca y selecciona al residente responsable de esta unidad. Si no aparece en la lista, asegúrate de que haya sido dado de alta previamente en el directorio.",
            items: formState.residents,
            value: null,
            itemLabel: (resident) => resident.user.name,
            onChanged: (resident) => cubit.onResidentSelected(resident),
          ),
          SizedBox(height: 20.0),

          TextInputField(
            label: 'Descripción',
            hint: 'Breve descripción de la propiedad...',
            isRequired: false,
            helpText:
                'Puedes incluir detalles adicionales como la ubicación de la torre, puntos de referencia o notas internas para la administración.',
            onChanged: cubit.updateDescription,
          ),
          const SizedBox(height: 24.0),

          // HeaderText.four('Foto de la propiedad'),
          // BodyText.small('Selecciona la opción para elegir una imagen.'),
          // const SizedBox(height: 16.0),

          // // --- Image Selection / Preview Area ---
          // if (formState.receiptImage != null)
          //   ImagePreview(imagePath: formState.receiptImage!.path, onDelete: () => cubit.removeImage)
          // else
          //   ImagePickerButtons(
          //     onCamera: () => cubit.pickImage(ImageSource.camera),
          //     onGallery: () => cubit.pickImage(ImageSource.gallery),
          //   ),
          // const SizedBox(height: 24.0),
          Center(
            child: PrimaryCtaButton(
              label: 'REGISTRAR PROPIEDAD',
              // icon: Icons.add_home,
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
  const _NoContractsFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Visual indicator for missing configuration
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: BaseAppColors.secondary.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(Icons.description_outlined, size: 64, color: BaseAppColors.secondary),
          ),
          const SizedBox(height: 32),

          HeaderText.four('No hay contratos activos', textAlign: TextAlign.center, color: const Color(0xFF1A4644)),
          const SizedBox(height: 16),

          Text(
            'Para registrar una propiedad, primero necesitas definir al menos un tipo de contrato (ej: Mensualidad, Mantenimiento).',
            textAlign: TextAlign.center,
            style: GoogleFonts.raleway(fontSize: 15, color: Colors.grey.shade600, height: 1.5),
          ),
          const SizedBox(height: 48),

          // Action to fix the missing requirement
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A4644),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () => Go.to(RegisterContractPage()),
              child: Text(
                'Configurar Contratos',
                style: GoogleFonts.raleway(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
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
