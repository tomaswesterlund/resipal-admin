import 'package:equatable/equatable.dart';

class OnboardingCommunityRegistrationFormState extends Equatable {
  final String name;
  final String address;
  final String location;

  bool get canSubmit {
    return name.trim().isNotEmpty && address.trim().isNotEmpty;
  }

  const OnboardingCommunityRegistrationFormState({this.name = '', this.address = '', this.location = ''});

  OnboardingCommunityRegistrationFormState copyWith({String? name, String? address, String? location}) {
    return OnboardingCommunityRegistrationFormState(
      name: name ?? this.name,
      address: address ?? this.address,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'address': address, 'location': location};
  }

  @override
  List<Object?> get props => [name, address, location];
}
