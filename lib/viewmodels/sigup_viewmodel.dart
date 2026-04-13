class SignupViewModel {
  String fullName = '';
  String email = '';
  String birthDate = '';
  String phoneNumber = '';
  String nim = '';
  String password = '';

  bool isPasswordHidden = true;
  bool isLoading = false;

  void setFullName(String value) {
    fullName = value;
  }

  void setEmail(String value) {
    email = value;
  }

  void setBirthDate(String value) {
    birthDate = value;
  }

  void setPhoneNumber(String value) {
    phoneNumber = value;
  }

  void setNim(String value) {
    nim = value;
  }

  void setPassword(String value) {
    password = value;
  }

  void togglePassword() {
    isPasswordHidden = !isPasswordHidden;
  }

  bool validate() {
    return fullName.isNotEmpty &&
        email.isNotEmpty &&
        birthDate.isNotEmpty &&
        phoneNumber.isNotEmpty &&
        nim.isNotEmpty &&
        password.isNotEmpty;
  }

  String? validateMessage() {
    if (fullName.isEmpty) return "Nama lengkap wajib diisi";
    if (email.isEmpty) return "Email wajib diisi";
    if (!email.contains('@')) return "Format email tidak valid";
    if (birthDate.isEmpty) return "Tanggal lahir wajib diisi";
    if (phoneNumber.isEmpty) return "Nomor telepon wajib diisi";
    if (nim.isEmpty) return "NIM wajib diisi";
    if (password.isEmpty) return "Password wajib diisi";
    if (password.length < 8) return "Password minimal 8 karakter";
    return null;
  }

  String get formattedBirthDate {
    if (birthDate.isEmpty) return '';

    final parts = birthDate.split('/');
    if (parts.length != 3) return birthDate;

    final day = parts[0];
    final month = parts[1];
    final year = parts[2];

    return '$year-$month-$day';
  }
}
