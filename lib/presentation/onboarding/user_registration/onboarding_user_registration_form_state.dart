import 'package:equatable/equatable.dart';

class OnboardingUserRegistrationFormState extends Equatable {
  final String name;
  final String phoneNumber;
  final String? emergencyPhoneNumber;
  final String email;

  bool get canSubmit {
    if (name.trim().isEmpty) return false;
    if (phoneNumber.trim().isEmpty) return false;
    if (email.trim().isEmpty) return false;

    return true;
  }

  const OnboardingUserRegistrationFormState({
    this.name = '',
    this.phoneNumber = '',
    this.emergencyPhoneNumber = '',
    this.email = '',
  });

  OnboardingUserRegistrationFormState copyWith({String? name, String? phoneNumber, String? emergencyPhoneNumber, String? email}) {
    return OnboardingUserRegistrationFormState(
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      emergencyPhoneNumber: emergencyPhoneNumber ?? this.emergencyPhoneNumber,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'phoneNumber': phoneNumber,
      'emergencyPhoneNumber': emergencyPhoneNumber,
      'email': email,
    };
  }

  @override
  List<Object?> get props => [name, phoneNumber, emergencyPhoneNumber, email];
}
