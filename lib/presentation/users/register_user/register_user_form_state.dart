import 'package:equatable/equatable.dart';

class RegisterUserFormState extends Equatable {
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? emergencyPhoneNumber;
  final bool isAdmin;
  final bool isResident;
  final bool isSecuriy;

  const RegisterUserFormState({
    this.name,
    this.email,
    this.phoneNumber,
    this.emergencyPhoneNumber,
    this.isAdmin = false,
    this.isResident = false,
    this.isSecuriy = false,
  });

  bool get canSubmit {
    if (name == null) return false;
    if (email == null) return false;
    if (phoneNumber == null) return false;
    if (isAdmin == false && isResident == false && isSecuriy == false) return false;
    return true;
  }

  RegisterUserFormState copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? emergencyPhoneNumber,
    bool? isAdmin,
    bool? isResident,
    bool? isSecuriy,
  }) {
    return RegisterUserFormState(
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      emergencyPhoneNumber: emergencyPhoneNumber ?? this.emergencyPhoneNumber,
      isAdmin: isAdmin ?? this.isAdmin,
      isResident: isResident ?? this.isResident,
      isSecuriy: isSecuriy ?? this.isSecuriy,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'emergencyPhoneNumber': emergencyPhoneNumber,
      'isAdmin': isAdmin,
      'isResident': isResident,
      'isSecuriy': isSecuriy,
    };
  }

  @override
  List<Object?> get props => [name, email, phoneNumber, emergencyPhoneNumber, isAdmin, isResident, isSecuriy];
}
