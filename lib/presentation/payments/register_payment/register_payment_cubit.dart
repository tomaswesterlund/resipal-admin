import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resipal_admin/admin_session_service.dart';
import 'package:resipal_admin/presentation/payments/register_payment/register_payment_form_state.dart';
import 'package:resipal_admin/presentation/payments/register_payment/register_payment_state.dart';
import 'package:resipal_core/domain/entities/resident_entity.dart';
import 'package:resipal_core/domain/use_cases/register_payment.dart';
import 'package:resipal_core/domain/use_cases/residents/get_residents_by_community.dart';
import 'package:resipal_core/services/image_service.dart';
import 'package:resipal_core/services/logger_service.dart';

class RegisterPaymentCubit extends Cubit<RegisterPaymentState> {
  final AdminSessionService _sessionService = GetIt.I<AdminSessionService>();
  final LoggerService _logger = GetIt.I<LoggerService>();
  final ImageService _imageService = GetIt.I<ImageService>();


  final ImagePicker _picker = ImagePicker();

  RegisterPaymentCubit() : super(InitialState());

  late RegisterPaymentFormState _formState;

  Future initialize() async {
    final residents = GetResidentsByCommunity().call(_sessionService.communityId);

    if (residents.isEmpty) {
      emit(NoResidentsFound());
      return;
    }

    _formState = RegisterPaymentFormState(residents: residents);
    emit(FormEditingState(_formState));
  }

  void updateResident(ResidentEntity? newResident) {
    _formState = _formState.copyWith(resident: newResident);
    emit(FormEditingState(_formState));
  }

  void updateAmount(double newAmount) {
    _formState = _formState.copyWith(amount: newAmount);
    emit(FormEditingState(_formState));
  }

  void updateReference(String newReference) {
    _formState = _formState.copyWith(reference: newReference);
    emit(FormEditingState(_formState));
  }

  void updateNote(String newNote) {
    _formState = _formState.copyWith(note: newNote);
    emit(FormEditingState(_formState));
  }

  void pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source, imageQuality: 70);

      if (image != null) {
        _formState = _formState.copyWith(receiptImage: image);
        emit(FormEditingState(_formState));
      }
    } catch (e, stack) {
      await _logger.logException(
        exception: e,
        stackTrace: stack,
        featureArea: 'RegisterPaymentCubit.pickImage',
        metadata: {'source': source.toString(), 'device_time': DateTime.now().toIso8601String()},
      );

      emit(ErrorState());
    }
  }

  void removeImage() {
    _formState = _formState.copyWith(receiptImage: null);
    emit(FormEditingState(_formState));
  }

  Future<void> submit() async {
    if (state is! FormEditingState) return;
    if (_formState.canSubmit == false) return;

    emit(FormSubmittingState());
    try {
      final imagePath = await _imageService.uploadPaymentReceipt(
        xFile: _formState.receiptImage!,
        communityId: _sessionService.communityId,
        residentId: _formState.resident!.id,
      );

      await RegisterPayment().call(
        communityId: _sessionService.communityId,
        amountInCents: _formState.amountInCents,
        date: DateTime.now(),
        reference: _formState.reference,
        note: _formState.note,
        receiptPath: imagePath,
      );

      emit(FormSubmittedSuccessfullyState());
    } catch (e, s) {
      await _logger.logException(
        exception: e,
        stackTrace: s,
        featureArea: 'RegisterPaymentCubit.submit',
        metadata: _formState.toMap(),
      );
      emit(ErrorState());
    }
  }
}
