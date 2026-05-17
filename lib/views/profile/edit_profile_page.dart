import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/user_profile_model.dart';
import '../../services/profile_service.dart';

class EditProfilePage extends StatefulWidget {
  final UserProfileModel profile;

  const EditProfilePage({
    super.key,
    required this.profile,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final ProfileService profileService = ProfileService();
  final ImagePicker _picker = ImagePicker();

  File? _selectedAvatarFile;
  bool isUploadingAvatar = false;
  bool hasAvatarChanged = false;

  late final TextEditingController usernameController;
  late final TextEditingController emailController;
  late final TextEditingController descriptionController;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  static const Color primaryRed = Color(0xFFED0711);
  static const Color pageBg = Color(0xFFF4F5F7);
  static const Color textDark = Color(0xFF111827);
  static const Color textGrey = Color(0xFF6B7280);

  @override
  void initState() {
    super.initState();

    usernameController = TextEditingController(
      text: widget.profile.displayUsername,
    );

    emailController = TextEditingController(
      text: widget.profile.email,
    );

    descriptionController = TextEditingController(
      text: widget.profile.description ?? '',
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    descriptionController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isAllowedImageFile(String path) {
    final lowerPath = path.toLowerCase();

    return lowerPath.endsWith('.jpg') ||
        lowerPath.endsWith('.jpeg') ||
        lowerPath.endsWith('.png');
  }

  Future<void> _pickAndUploadAvatar() async {
    if (isLoading || isUploadingAvatar) {
      return;
    }
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1024,
      );

      if (pickedFile == null) {
        return;
      }

      if (!_isAllowedImageFile(pickedFile.path)) {
        _showMessage('Format foto harus JPG, JPEG, atau PNG');
        return;
      }

      final file = File(pickedFile.path);

      setState(() {
        _selectedAvatarFile = file;
        isUploadingAvatar = true;
      });

      await profileService.uploadAvatar(file);

      if (!mounted) return;

      setState(() {
        isUploadingAvatar = false;
        hasAvatarChanged = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto profile berhasil diperbarui'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isUploadingAvatar = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    }
  }

  String _initials(String name) {
    final cleanName = name.trim();

    if (cleanName.isEmpty) return 'MS';

    final parts = cleanName.split(' ').where((e) => e.isNotEmpty).toList();

    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }

    return cleanName.substring(0, 1).toUpperCase();
  }

  String? _avatarUrl() {
    final userId = widget.profile.id.trim();

    if (userId.isEmpty) {
      return null;
    }

    return profileService.buildAvatarUrl(userId);
  }

  Widget _profileAvatar() {
    final avatarUrl = _avatarUrl();

    Widget fallbackAvatar() {
      return Container(
        width: 74,
        height: 74,
        decoration: const BoxDecoration(
          color: Color(0xFF0B6B4E),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            _initials(widget.profile.displayName),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      );
    }

    Widget avatarContent;

    if (_selectedAvatarFile != null) {
      avatarContent = ClipOval(
        child: Image.file(
          _selectedAvatarFile!,
          width: 74,
          height: 74,
          fit: BoxFit.cover,
        ),
      );
    } else if (avatarUrl != null) {
      avatarContent = ClipOval(
        child: Image.network(
          avatarUrl,
          width: 74,
          height: 74,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return fallbackAvatar();
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return fallbackAvatar();
          },
        ),
      );
    } else {
      avatarContent = fallbackAvatar();
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        avatarContent,
        if (isUploadingAvatar)
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.35),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: primaryRed,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: primaryRed,
          width: 1.2,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: primaryRed,
          width: 1,
        ),
      ),
    );
  }

  Widget _formField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: textGrey,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 34,
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: const TextStyle(
              color: textDark,
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
            decoration: _inputDecoration(
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSave() async {
    if (isUploadingAvatar) {
      _showMessage('Tunggu upload foto selesai');
      return;
    }
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final description = descriptionController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (username.isEmpty) {
      _showMessage('Username wajib diisi');
      return;
    }

    if (email.isEmpty || !email.contains('@')) {
      _showMessage('Email tidak valid');
      return;
    }

    if (password.isNotEmpty && password.length < 8) {
      _showMessage('Password minimal 8 karakter');
      return;
    }

    if (password.isNotEmpty && password != confirmPassword) {
      _showMessage('Konfirmasi password tidak sama');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await profileService.updateProfile(
        username: username,
        email: email,
        description: description,
      );

      if (password.isNotEmpty) {
        await profileService.updatePassword(
          password: password,
        );
      }

      if (!mounted) return;

      _showMessage('Profile berhasil diperbarui');

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 122,
      color: Colors.white,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 28,
        left: 32,
        right: 32,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.pop(context, hasAvatarChanged),
              child: Container(
                width: 33,
                height: 33,
                decoration: BoxDecoration(
                  color: primaryRed,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 19,
                ),
              ),
            ),
          ),
          const Text(
            'Edit Profile',
            style: TextStyle(
              color: textDark,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 32,
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: isUploadingAvatar ? null : _pickAndUploadAvatar,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                _profileAvatar(),
                Positioned(
                  right: -2,
                  bottom: 6,
                  child: Container(
                    width: 19,
                    height: 19,
                    decoration: const BoxDecoration(
                      color: primaryRed,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: isUploadingAvatar ? null : _pickAndUploadAvatar,
            child: Text(
              isUploadingAvatar ? 'Mengupload...' : 'Ganti Foto Profil',
              style: const TextStyle(
                color: textGrey,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(28, 44, 28, 0),
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 10),
      decoration: BoxDecoration(
        color: pageBg,
        border: Border.all(
          color: primaryRed,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _formField(
            label: 'Username',
            controller: usernameController,
          ),
          const SizedBox(height: 17),
          _formField(
            label: 'Email',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 17),
          _formField(
            label: 'Deskripsi',
            controller: descriptionController,
          ),
          const SizedBox(height: 17),
          _formField(
            label: 'Password',
            controller: passwordController,
            obscureText: obscurePassword,
            suffixIcon: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                setState(() {
                  obscurePassword = !obscurePassword;
                });
              },
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                size: 18,
                color: textDark,
              ),
            ),
          ),
          const SizedBox(height: 17),
          _formField(
            label: 'Konfirmasi password',
            controller: confirmPasswordController,
            obscureText: true,
          ),
          const SizedBox(height: 36),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 80,
              height: 31,
              child: ElevatedButton(
                onPressed:
                    (isLoading || isUploadingAvatar) ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: primaryRed,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        isUploadingAvatar ? '...' : 'Simpan',
                        style: const TextStyle(
                          fontSize: 14,
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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;

        Navigator.pop(context, hasAvatarChanged);
      },
      child: Scaffold(
        backgroundColor: pageBg,
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              _buildAvatarSection(),
              _buildFormCard(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
