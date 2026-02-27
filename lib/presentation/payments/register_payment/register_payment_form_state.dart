// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resipal_core/lib.dart';

class RegisterPaymentFormState extends Equatable {
  final List<ResidentEntity> residents;
  final ResidentEntity? resident;
  final double amount;
  final DateTime? payDate;
  final String reference;
  final String note;
  final XFile? receiptImage;

  const RegisterPaymentFormState({
    required this.residents,
    this.resident,
    this.amount = 0.0,
    this.payDate,
    this.reference = '',
    this.note = '',
    this.receiptImage,
  });

  bool get canSubmit => resident != null && amount > 0 && payDate != null && reference.isNotEmpty && receiptImage != null;

  int get amountInCents => (amount * 100).toInt();

  RegisterPaymentFormState copyWith({
    List<ResidentEntity>? residents,
    ResidentEntity? resident,
    double? amount,
    DateTime? payDate,
    String? reference,
    String? note,
    XFile? receiptImage,
  }) {
    return RegisterPaymentFormState(
      residents: residents ?? this.residents,
      resident: resident ?? this.resident,
      amount: amount ?? this.amount,
      payDate: payDate ?? this.payDate,
      reference: reference ?? this.reference,
      note: note ?? this.note,
      receiptImage: receiptImage ?? this.receiptImage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'residentId': resident?.user.id,
      'amount': amount,
      'payDate': payDate,
      'reference': reference,
      'note': note,
      'receiptImage': receiptImage?.path,
    };
  }

  @override
  List<Object?> get props => [residents, resident, amount, payDate, reference, note, receiptImage];
}
