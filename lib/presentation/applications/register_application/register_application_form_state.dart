import 'package:equatable/equatable.dart';
import 'package:resipal_core/lib.dart';

class RegisterApplicationFormState extends Equatable {
  final String name;
  final String email;
  final String phoneNumber;
  final String? emergencyPhoneNumber;
  final String message;
  final bool isAdmin;
  final bool isResident;
  final bool isSecurity;

  const RegisterApplicationFormState({
    this.name = '',
    this.email = '',
    this.phoneNumber = '',
    this.emergencyPhoneNumber,
    this.message = '',
    this.isAdmin = false,
    this.isResident = true,
    this.isSecurity = false,
  });

  bool get canSubmit {
    if (name.isEmpty) return false;
    if (message.isEmpty) return false;
    if (Validators.isValidEmail(email) == false) return false;
    if (Validators.isValidPhone(phoneNumber) == false) return false;
    if (!isAdmin && !isResident && !isSecurity) return false;

    return true;
  }

  RegisterApplicationFormState copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? emergencyPhoneNumber,
    String? message,
    bool? isAdmin,
    bool? isResident,
    bool? isSecurity,
  }) {
    return RegisterApplicationFormState(
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      emergencyPhoneNumber: emergencyPhoneNumber ?? this.emergencyPhoneNumber,
      message: message ?? this.message,
      isAdmin: isAdmin ?? this.isAdmin,
      isResident: isResident ?? this.isResident,
      isSecurity: isSecurity ?? this.isSecurity,
    );
  }

  @override
  List<Object?> get props => [name, email, phoneNumber, emergencyPhoneNumber, message, isAdmin, isResident, isSecurity];
}
