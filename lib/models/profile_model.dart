class ProfileModel {
  final String id;
  final String email;
  final String? fullName;
  final String? phoneNumber;
  final String? nim;
  final String? birthDate;

  const ProfileModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.nim,
    required this.birthDate,
  });

  const ProfileModel.empty()
      : id = '',
        email = '',
        fullName = null,
        phoneNumber = null,
        nim = null,
        birthDate = null;

  String get displayName {
    if (fullName != null && fullName!.trim().isNotEmpty) {
      return fullName!;
    }
    return 'Mahasiswa';
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['full_name'],
      phoneNumber: json['phone_number'],
      nim: json['nim'],
      birthDate: json['birth_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'nim': nim,
      'birth_date': birthDate,
    };
  }
}
