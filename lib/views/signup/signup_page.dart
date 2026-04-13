import 'package:flutter/material.dart';
import 'package:mahasiswa_sukses/viewmodels/sigup_viewmodel.dart';
import 'package:mahasiswa_sukses/services/auth_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final vm = SignupViewModel();

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final birthDateController = TextEditingController();
  final phoneController = TextEditingController();
  final nimController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthService();

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    birthDateController.dispose();
    phoneController.dispose();
    nimController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({
    required String hintText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        fontSize: 15,
        color: Color(0xFF9B9B9B),
        fontWeight: FontWeight.w400,
      ),
      filled: true,
      fillColor: const Color(0xFFFFFFFF),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFEAEAEA),
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFEAEAEA),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFFF4D57),
          width: 1.3,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    TextEditingController? controller,
    Function(String)? onChanged,
    TextInputType? keyboardType,
    bool readOnly = false,
    bool obscureText = false,
    Widget? suffixIcon,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF8D8D8D),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: keyboardType,
          readOnly: readOnly,
          obscureText: obscureText,
          onTap: onTap,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF4A4A4A),
            fontWeight: FontWeight.w400,
          ),
          decoration: _inputDecoration(
            hintText: hintText,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }

  Future<void> _selectBirthDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      final day = pickedDate.day.toString().padLeft(2, '0');
      final month = pickedDate.month.toString().padLeft(2, '0');
      final year = pickedDate.year.toString();

      final formatted = '$day/$month/$year';
      birthDateController.text = formatted;
      vm.setBirthDate(formatted);
      setState(() {});
    }
  }

  Future<void> _handleRegister() async {
    final error = vm.validateMessage();

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return;
    }

    setState(() {
      vm.isLoading = true;
    });

    try {
      await authService.register(
        fullName: vm.fullName,
        email: vm.email,
        birthDate: vm.formattedBirthDate,
        phoneNumber: vm.phoneNumber,
        nim: vm.nim,
        password: vm.password,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Register berhasil')),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      final message = e.toString().replaceFirst('Exception: ', '');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      if (mounted) {
        setState(() {
          vm.isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFF3131),
              Color(0xFF9F0015),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDFDFD),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        splashRadius: 22,
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 26,
                          color: Color(0xFF2B2B2B),
                        ),
                      ),
                      const SizedBox(height: 26),
                      const Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1D2433),
                          height: 1.1,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF8F8F8F),
                              fontWeight: FontWeight.w400,
                            ),
                            children: [
                              TextSpan(text: 'Sudah punya akun ? '),
                              TextSpan(
                                text: 'Login',
                                style: TextStyle(
                                  color: Color(0xFF2F80ED),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      _buildTextField(
                        label: 'Nama Lengkap',
                        hintText: 'Nama Lengkap',
                        controller: fullNameController,
                        onChanged: vm.setFullName,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Email',
                        hintText: 'Contoh@gmail.com',
                        controller: emailController,
                        onChanged: vm.setEmail,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Tanggal Lahir',
                        hintText: 'dd/mm/yyyy',
                        controller: birthDateController,
                        onChanged: vm.setBirthDate,
                        readOnly: true,
                        onTap: _selectBirthDate,
                        suffixIcon: const Padding(
                          padding: EdgeInsets.only(right: 14),
                          child: Icon(
                            Icons.calendar_today_outlined,
                            size: 20,
                            color: Color(0xFF8A8A8A),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'No Telepon',
                        hintText: '0812-3245-2311',
                        controller: phoneController,
                        onChanged: vm.setPhoneNumber,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'NIM',
                        hintText: 'Masukkan NIM',
                        controller: nimController,
                        onChanged: vm.setNim,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Password',
                        hintText: '*******',
                        controller: passwordController,
                        onChanged: vm.setPassword,
                        obscureText: vm.isPasswordHidden,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              vm.togglePassword();
                            });
                          },
                          icon: Icon(
                            vm.isPasswordHidden
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 22,
                            color: const Color(0xFF6F6672),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFFFF3D4D),
                                Color(0xFFFF2338),
                              ],
                            ),
                            border: Border.all(
                              color: const Color(0xFF4A78FF),
                              width: 1,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x22000000),
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: vm.isLoading ? null : _handleRegister,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: vm.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Register',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
