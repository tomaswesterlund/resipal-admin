import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resipal_admin/admin_session_service.dart';
import 'package:resipal_admin/presentation/properties/register_property/register_property_form_state.dart';
import 'package:resipal_admin/presentation/properties/register_property/register_property_state.dart';
import 'package:resipal_core/lib.dart';



class RegisterPropertyCubit extends Cubit<RegisterPropertyState> {
  final ImageService _imageService = GetIt.I<ImageService>();
  final LoggerService _logger = GetIt.I<LoggerService>();
  final AdminSessionService _sessionService = GetIt.I<AdminSessionService>();

  RegisterPropertyCubit() : super(InitialState());

  final ImagePicker _picker = ImagePicker();

  late RegisterPropertyFormState _formState;

  void initialize() {
    final contracts = GetContractsByCommunity().call(_sessionService.communityId);

    // TODO: Watch Contracts here ...

    if (contracts.isEmpty) {
      emit(NoContractsFound());
      return;
    }

    final residents = GetResidentsByCommunity().call(_sessionService.communityId);

    _formState = RegisterPropertyFormState(residents: residents, contracts: contracts);
    emit(FormEditingState(_formState));
  }

  void onContractSelected(ContractEntity? newContract) {
    _formState = _formState.copyWith(contract: newContract);
    emit(FormEditingState(_formState));
  }

  void onResidentSelected(ResidentEntity? newResident) {
    _formState = _formState.copyWith(resident: newResident);
    emit(FormEditingState(_formState));
  }

  void updateName(String newName) {
    _formState = _formState.copyWith(name: newName);
    emit(FormEditingState(_formState));
  }

  void updateDescription(String newDescription) {
    _formState = _formState.copyWith(name: newDescription);
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
        featureArea: 'RegisterPropertyCubit.pickImage',
        metadata: {'source': source.toString(), 'device_time': DateTime.now().toIso8601String()},
      );

      emit(ErrorState());
    }
  }

  void removeImage() {
    _formState = _formState.copyWith(receiptImage: null);
    emit(FormEditingState(_formState));
  }

  Future submit() async {
    try {
      if (_formState.canSubmit == false) {
        emit(ErrorState());
        return;
      }

      emit(FormSubmittingState());
      final communityId = _sessionService.communityId;

      final propertyId = await RegisterProperty().call(
        communityId: communityId,
        residentId: _formState.resident!.id,
        contractId: _formState.contract!.id,
        name: _formState.name!,
        description: _formState.description,
      );

      await FetchPropertyById().call(propertyId);

      emit(FormSubmittedSuccessfullyState());
    } catch (e, s) {
      await _logger.logException(
        exception: e,
        stackTrace: s,
        featureArea: 'RegisterPropertyCubit.submit',
        // TODO: Add metadata
        //metadata: _formState.toString(),
      );
      emit(ErrorState());
    }
  }
}
