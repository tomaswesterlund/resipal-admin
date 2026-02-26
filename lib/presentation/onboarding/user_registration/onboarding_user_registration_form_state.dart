import 'package:equatable/equatable.dart';

class OnboardingUserRegistrationFormState extends Equatable {
  final String name;
  final String phoneNumber;
  final String email;

  bool get canSubmit {
    if (name.trim().isEmpty) return false;
    if (phoneNumber.trim().isEmpty) return false;
    if (email.trim().isEmpty) return false;
    
    return true;
  }

  OnboardingUserRegistrationFormState({this.name = '', this.phoneNumber = '', this.email = ''});

  OnboardingUserRegistrationFormState copyWith({String? name, String? phoneNumber, String? email}) {
    return OnboardingUserRegistrationFormState(
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'name': name, 'phoneNumber': phoneNumber, 'email': email};
  }
  
  @override
  // TODO: implement props
  List<Object?> get props => [name, phoneNumber, email];
}
