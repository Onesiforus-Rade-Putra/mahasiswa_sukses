import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/setting_viewmodel.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  static const Color primaryRed = Color(0xFFED1E28);
  static const Color pageBg = Color(0xFFF6F6F6);

  late TextEditingController nameController;
  late TextEditingController emailController;
  final TextEditingController passwordController =
      TextEditingController(text: "**********");
  final TextEditingController confirmPasswordController =
      TextEditingController(text: "**********");

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();

    final vm = context.read<SettingViewModel>();
    nameController = TextEditingController(text: vm.name);
    emailController = TextEditingController(text: vm.email);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SettingViewModel>();

    return Scaffold(
      backgroundColor: pageBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildProfilePhoto(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 28, 28, 32),
                child: _buildFormCard(context, vm),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 112,
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 34,
              height: 34,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryRed,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  size: 18,
                ),
              ),
            ),
          ),
          const Text(
            "Edit Profile",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePhoto() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              _buildAvatar(size: 76),
              Positioned(
                right: 3,
                bottom: 3,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: primaryRed,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "Ganti Foto Profil",
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF7A7A7A),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard(BuildContext context, SettingViewModel vm) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 22, 14, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: primaryRed, width: 1),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel("Nama Lengkap"),
          _buildTextField(
            controller: nameController,
            hintText: "Nama Lengkap",
          ),
          const SizedBox(height: 14),
          _buildLabel("Email"),
          _buildTextField(
            controller: emailController,
            hintText: "Email",
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 14),
          _buildLabel("Password"),
          _buildTextField(
            controller: passwordController,
            hintText: "Password",
            obscureText: !isPasswordVisible,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
              icon: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                size: 20,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 14),
          _buildLabel("Konfirmasi password"),
          _buildTextField(
            controller: confirmPasswordController,
            hintText: "Konfirmasi password",
            obscureText: !isConfirmPasswordVisible,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  isConfirmPasswordVisible = !isConfirmPasswordVisible;
                });
              },
              icon: Icon(
                isConfirmPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                size: 20,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 34),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 34,
              width: 76,
              child: ElevatedButton(
                onPressed: () {
                  vm.updateProfile(
                    newName: nameController.text.trim(),
                    newEmail: emailController.text.trim(),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Profil berhasil disimpan"),
                    ),
                  );

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryRed,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text(
                  "Simpan",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF7A7A7A),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return SizedBox(
      height: 36,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 12,
            color: Color(0xFF999999),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          suffixIcon: suffixIcon,
          suffixIconConstraints: const BoxConstraints(
            minWidth: 38,
            minHeight: 36,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(
              color: primaryRed,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(
              color: primaryRed,
              width: 1.4,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar({required double size}) {
    return ClipOval(
      child: Image.asset(
        "assets/images/profile_dummy.png",
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: size,
            height: size,
            color: const Color(0xFFEAEAEA),
            child: Icon(
              Icons.person,
              size: size * 0.55,
              color: Colors.grey,
            ),
          );
        },
      ),
    );
  }
}
