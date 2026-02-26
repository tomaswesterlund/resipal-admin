import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resipal_admin/presentation/contracts/contract_card.dart';
import 'package:resipal_admin/presentation/contracts/register_contract/register_contract_page.dart';
import 'package:resipal_admin/shared/buttons/primary_cta_button.dart';
import 'package:resipal_admin/shared/loading/loading_bar.dart';
import 'package:resipal_admin/shared/state_switcher.dart';
import 'package:resipal_admin/shared/views/error_view.dart';
import 'package:resipal_core/presentation/shared/colors/base_app_colors.dart';
import 'package:resipal_core/presentation/shared/my_app_bar.dart';
import 'package:resipal_core/presentation/shared/texts/header_text.dart';
import 'package:short_navigation/short_navigation.dart';
import 'contract_list_cubit.dart';
import 'contract_list_state.dart';

class ContractListPage extends StatelessWidget {
  const ContractListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContractListCubit()..initialize(),
      child: Scaffold(
        backgroundColor: BaseAppColors.background,
        appBar: const MyAppBar(title: 'Contratos y Cuotas'),
        body: BlocBuilder<ContractListCubit, ContractListState>(
          builder: (context, state) {
            return StateSwitcher(child: _buildStateWidget(state));
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF1A4644),
          onPressed: () => Go.to(RegisterContractPage()),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildStateWidget(ContractListState state) {
    if (state is LoadingState) {
      return LoadingBar(key: const ValueKey('loading'), title: 'Cargando contratos ...');
    }

    if (state is ErrorState) {
      return ErrorView(key: const ValueKey('error'));
    }

    if (state is EmptyState) {
      return _Empty(key: const ValueKey('empty'));
    }

    if (state is LoadedState) {
      return ListView.builder(
        key: const ValueKey('loaded'), // Crucial for AnimatedSwitcher
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        itemCount: state.contracts.length,
        itemBuilder: (context, index) => ContractCard(state.contracts[index]),
      );
    }

    return const SizedBox.shrink(key: ValueKey('none'));
  }
}

class _Empty extends StatelessWidget {
  const _Empty({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Visual indicator (Empty clipboard/document icon)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: const Color(0xFF1A4644).withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.assignment_add, size: 64, color: Color(0xFF1A4644)),
          ),
          const SizedBox(height: 32),

          HeaderText.four('Sin contratos configurados', textAlign: TextAlign.center, color: const Color(0xFF1A4644)),
          const SizedBox(height: 16),

          Text(
            'Los contratos definen los montos y periodos de cobro para tus residentes (ej: Cuota de Mantenimiento). Necesitas crear al menos uno para empezar a registrar propiedades.',
            textAlign: TextAlign.center,
            style: GoogleFonts.raleway(fontSize: 15, color: Colors.grey.shade600, height: 1.5),
          ),
          const SizedBox(height: 48),

          PrimaryCtaButton(label: 'Configurar mi primer contrato', onPressed: () => Go.to(RegisterContractPage())),
        ],
      ),
    );
  }
}
