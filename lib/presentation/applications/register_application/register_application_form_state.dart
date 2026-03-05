import 'package:equatable/equatable.dart';

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

  bool get canSubmit =>
      name.isNotEmpty &&
      email.contains('@') &&
      phoneNumber.isNotEmpty &&
      message.isNotEmpty &&
      (isAdmin || isResident || isSecurity);

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
