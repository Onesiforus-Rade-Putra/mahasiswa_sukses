class SignupViewModel {
  String fullName = '';
  String email = '';
  String username = '';
  String phoneNumber = '';
  String password = '';

  bool isPasswordHidden = true;
  bool isLoading = false;

  void setFullName(String value) {
    fullName = value.trim();
  }

  void setEmail(String value) {
    email = value.trim();
  }

  void setUsername(String value) {
    username = value.trim();
  }

  void setPhoneNumber(String value) {
    phoneNumber = value.trim();
  }

  void setPassword(String value) {
    password = value;
  }

  void togglePassword() {
    isPasswordHidden = !isPasswordHidden;
  }

  String? validateMessage() {
    if (fullName.isEmpty) return 'Nama lengkap wajib diisi';

    if (email.isEmpty) return 'Email wajib diisi';
    if (!email.contains('@')) return 'Format email tidak valid';

    if (username.isEmpty) return 'Username wajib diisi';

    if (phoneNumber.isEmpty) return 'Nomor telepon wajib diisi';

    if (password.isEmpty) return 'Password wajib diisi';
    if (password.length < 8) return 'Password minimal 8 karakter';

    return null;
  }
}
