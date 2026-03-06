import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:resipal_admin/presentation/reports/member_breakdown_report/member_breakdown_report_cubit.dart';
import 'package:resipal_admin/presentation/reports/member_breakdown_report/member_breakdown_report_state.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class MemberBreakdownReportPage extends StatelessWidget {
  const MemberBreakdownReportPage({super.key});

  Future<void> _generatePdf(LoadedState state) async {
    final pdf = pw.Document();
    final formatCurrency = NumberFormat.simpleCurrency();

    // 1. Load Assets (Fonts & Logo) to prevent Cupertino errors

    // Load logo from assets
    final logoData = await rootBundle.load('assets/resipal_logo_green.png');
    final logoImage = pw.MemoryImage(logoData.buffer.asUint8List());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        //theme: pw.ThemeData.withFont(base: font, bold: boldFont),
        build: (context) => [
          // --- HEADER WITH LOGO ---
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Row(
                children: [
                  pw.Image(logoImage, width: 50),
                  pw.SizedBox(width: 8.0),
                  pw.Text('RESIPAL', style: pw.TextStyle(fontSize: 36, fontWeight: pw.FontWeight.bold)),
                ],
              ),

              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('Desglose de miembros', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
                  pw.Text(
                    'Comunidad: ${state.community.name}',
                    style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
                  ),
                  pw.Text(
                    'Generado el: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
                    style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                  ),
                ],
              ),
            ],
          ),

          pw.SizedBox(height: 25),

          // --- DASHBOARD SUMMARY BOXES ---
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _buildStatBox('Miembros', '${state.members.length}'),
              _buildStatBox('Propiedades', '${state.members.fold(0, (sum, m) => sum + m.propertyRegistry.count)}'),
              _buildStatBox(
                'Por Revisar',
                formatCurrency.format(state.totalPendingCents / 100),
                valueColor: PdfColors.orange,
              ),
              _buildStatBox(
                'Deuda Total',
                formatCurrency.format(state.totalDebtCents / 100),
                valueColor: PdfColors.red,
              ),
            ],
          ),

          pw.SizedBox(height: 20),
          pw.Divider(thickness: 1, color: PdfColors.grey300),
          pw.SizedBox(height: 15),

          // --- DATA TABLE ---
          pw.TableHelper.fromTextArray(
            border: null,
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey800),
            cellHeight: 25,
            cellAlignments: {
              0: pw.Alignment.centerLeft, // Nombre
              1: pw.Alignment.centerLeft, // Propiedades
              2: pw.Alignment.centerRight, // Balance
              3: pw.Alignment.centerRight, // Pendiente
              4: pw.Alignment.centerRight, // Deuda
            },
            headers: ['Nombre', 'Propiedades', 'Balance', 'Pendiente', 'Deuda'],
            data: state.members.expand((m) {
              final properties = m.propertyRegistry.properties;

              // 1. The main row for the Member
              final mainRow = [
                m.name,
                properties.length == 1 ? properties.first.name : '', // If only 1, show here. If many, leave empty.
                formatCurrency.format(m.paymentLedger.totalBalanceInCents / 100),
                formatCurrency.format(m.paymentLedger.pendingPaymentAmountInCents / 100),
                properties.length == 1
                    ? formatCurrency.format(-1)
                    : formatCurrency.format(m.propertyRegistry.totalOverdueFeeInCents / 100),
              ];

              // 2. If multiple properties, create sub-rows
              if (properties.length > 1) {
                final subRows = properties
                    .map(
                      (p) => [
                        '', // Empty Name
                        p.name, // Property Name
                        '', // Empty Balance
                        '', // Empty Pendiente
                        CurrencyFormatter.fromCents(p.totalOverdueFeeInCents),
                      ],
                    )
                    .toList();

                return [mainRow, ...subRows];
              }

              return [mainRow];
            }).toList(),
            // Optional: Add a subtle line under each member group
            rowDecoration: const pw.BoxDecoration(
              border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey100, width: .5)),
            ),
          ),
        ],
      ),
    );

    // --- SAVE & OPEN ---
    final pdfService = GetIt.I<PdfService>();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final fileName = '${timestamp}_reporte_desglose_miembros.pdf';

    final file = await pdfService.save(name: fileName, pdf: pdf);
    await pdfService.open(file);
  }

  /// Helper for the Summary Boxes
  pw.Widget _buildStatBox(String title, String value, {PdfColor? valueColor}) {
    return pw.Container(
      width: 110,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey50,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
        border: pw.Border.all(color: PdfColors.grey200),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(title.toUpperCase(), style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey600)),
          pw.SizedBox(height: 4),
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: valueColor ?? PdfColors.black),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => MemberBreakdownReportCubit()..initialize(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: MyAppBar(
          title: 'Desglose de Miembros',
          actions: [
            // Use BlocBuilder here to access the current state data for the PDF
            BlocBuilder<MemberBreakdownReportCubit, MemberBreakdownReportState>(
              builder: (context, state) {
                if (state is LoadedState) {
                  return IconButton(
                    icon: const Icon(Icons.picture_as_pdf_rounded),
                    onPressed: () => _generatePdf(state),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocBuilder<MemberBreakdownReportCubit, MemberBreakdownReportState>(
          builder: (ctx, state) {
            if (state is LoadingState) return const LoadingView();
            if (state is ErrorState) return const ErrorView();

            if (state is LoadedState) {
              return Column(
                children: [
                  _SummaryHeader(
                    balance: state.totalBalanceCents,
                    debt: state.totalDebtCents,
                    pending: state.totalPendingCents,
                    count: state.members.length,
                  ),
                  Expanded(child: state.members.isEmpty ? const _EmptyReport() : _ReportList(members: state.members)),
                ],
              );
            }
            return const UnknownStateView();
          },
        ),
      ),
    );
  }
}

class _SummaryHeader extends StatelessWidget {
  final int balance;
  final int debt;
  final int pending; // Added
  final int count;

  const _SummaryHeader({required this.balance, required this.debt, required this.pending, required this.count});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.surface,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Prevent overflow if screen is narrow
        child: Row(
          children: [
            _HeaderItem(label: 'REGISTROS', value: count.toString()),
            const SizedBox(width: 24),
            _HeaderItem(
              label: 'BALANCE',
              customValue: AmountText.fromCents(balance, fontSize: 16, color: colorScheme.tertiary),
            ),
            const SizedBox(width: 24),
            _HeaderItem(
              label: 'POR REVISAR',
              customValue: AmountText.fromCents(pending, fontSize: 16, color: Colors.orange),
            ),
            const SizedBox(width: 24),
            _HeaderItem(
              label: 'DEUDA',
              customValue: AmountText.fromCents(debt, fontSize: 16, color: colorScheme.error),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemberReportTile extends StatelessWidget {
  final MemberEntity member;
  const _MemberReportTile(this.member);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final properties = member.propertyRegistry.properties.map((p) => p.name).join(', ');
    final pendingAmount = member.paymentLedger.pendingPaymentAmountInCents;

    return DefaultCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderText.five(member.name),
                      const SizedBox(height: 2),
                      BodyText.small(properties.isEmpty ? 'Sin propiedades' : properties, color: colorScheme.outline),
                    ],
                  ),
                ),
                if (pendingAmount > 0)
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.hourglass_empty_rounded, color: Colors.orange, size: 18),
                  ),
                if (member.propertyRegistry.hasDebt)
                  Icon(Icons.warning_amber_rounded, color: colorScheme.error, size: 20),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _AmountColumn(
                  label: 'BALANCE TOTAL',
                  cents: member.paymentLedger.totalBalanceInCents,
                  color: colorScheme.tertiary,
                ),
                _AmountColumn(
                  label: 'PENDIENTE',
                  cents: pendingAmount,
                  color: pendingAmount > 0 ? Colors.orange : colorScheme.onSurfaceVariant,
                ),
                _AmountColumn(
                  label: 'DEUDA VENCIDA',
                  cents: member.propertyRegistry.totalOverdueFeeInCents,
                  color: member.propertyRegistry.hasDebt ? colorScheme.error : colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportList extends StatelessWidget {
  final List<MemberEntity> members;
  const _ReportList({required this.members});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: members.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (ctx, index) => _MemberReportTile(members[index]),
    );
  }
}

class _HeaderItem extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? customValue;

  const _HeaderItem({required this.label, this.value, this.customValue});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w800, color: theme.colorScheme.outline),
        ),
        const SizedBox(height: 4),
        customValue ?? HeaderText.five(value!),
      ],
    );
  }
}

class _AmountColumn extends StatelessWidget {
  final String label;
  final int cents;
  final Color color;

  const _AmountColumn({required this.label, required this.cents, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
        AmountText.fromCents(cents, fontSize: 14, color: color),
      ],
    );
  }
}

class _EmptyReport extends StatelessWidget {
  const _EmptyReport();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BodyText.medium(
        'No se encontraron registros para este reporte.',
        color: Theme.of(context).colorScheme.inverseSurface,
      ),
    );
  }
}
