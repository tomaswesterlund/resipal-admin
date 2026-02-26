import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resipal_core/lib.dart';

class RegisterPropertyFormState extends Equatable {
  final List<ResidentEntity> residents;
  final List<ContractEntity> contracts;

  final ResidentEntity? resident;
  final ContractEntity? contract;
  final String? name;
  final String? description;

  bool get canSubmit {
    if (contract == null) return false;
    if (name == null) return false;
    return true;
  }

  const RegisterPropertyFormState({
    required this.contracts,
    required this.residents,
    this.contract,
    this.resident,
    this.name,
    this.description,
  });

  RegisterPropertyFormState copyWith({
    ContractEntity? contract,
    ResidentEntity? resident,

    String? name,
    String? description,
    XFile? receiptImage,
  }) {
    return RegisterPropertyFormState(
      contracts: contracts,
      residents: residents,
      contract: contract ?? this.contract,
      resident: resident ?? this.resident,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  @override
  String toString() {
    return 'RegisterPropertyFormState(resident: $resident, contract: $contract, name: $name, description: $description)';
  }

  @override
  List<Object?> get props => [residents, contracts, resident, contract, name, description];
}
