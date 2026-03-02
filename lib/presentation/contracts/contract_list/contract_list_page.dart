import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resipal_admin/presentation/contracts/contract_card.dart';
import 'package:resipal_admin/presentation/contracts/register_contract/register_contract_page.dart';
import 'package:wester_kit/lib.dart';
import 'package:short_navigation/short_navigation.dart';
import 'contract_list_cubit.dart';
import 'contract_list_state.dart';

class ContractListPage extends StatelessWidget {
  const ContractListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (context) => ContractListCubit()..initialize(),
      child: Scaffold(
        backgroundColor: colorScheme.background,
        appBar: const MyAppBar(title: 'Contratos y Cuotas'),
        body: BlocBuilder<ContractListCubit, ContractListState>(
          builder: (context, state) {
            return StateSwitcher(child: _buildStateWidget(context, state));
          },
        ),
        floatingActionButton: WkFloatingActionButton(onPressed: () => Go.to(const RegisterContractPage())),
      ),
    );
  }

  Widget _buildStateWidget(BuildContext context, ContractListState state) {
    if (state is LoadingState) {
      return const LoadingBar(key: ValueKey('loading'), title: 'Cargando contratos ...');
    }

    if (state is ErrorState) {
      return const ErrorView(key: ValueKey('error'));
    }

    if (state is EmptyState) {
      return const _Empty(key: ValueKey('empty'));
    }

    if (state is LoadedState) {
      return ListView.separated(
        key: const ValueKey('loaded'),
        padding: const EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 100.0), // Extra bottom padding for FAB
        itemCount: state.contracts.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: colorScheme.primary.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(Icons.assignment_add, size: 64, color: colorScheme.primary),
            ),
            const SizedBox(height: 32),
            HeaderText.four('Sin contratos configurados', textAlign: TextAlign.center, color: colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'Los contratos definen los montos y periodos de cobro para tus residentes. Necesitas crear al menos uno para empezar a registrar propiedades.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.outline, height: 1.5),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(label: 'CONFIGURAR CONTRATO', onPressed: () => Go.to(const RegisterContractPage())),
            ),
          ],
        ),
      ),
    );
  }
}
