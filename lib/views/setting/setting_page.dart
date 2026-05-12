import 'package:flutter/material.dart';

import '../../services/setting_service.dart';
import '../login/login_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final SettingService settingService = SettingService();

  SettingUserModel? user;
  bool isLoading = false;
  bool showAchievementRank = false;
  String? errorMessage;

  static const Color primaryRed = Color(0xFFED0711);
  static const Color pageBg = Color(0xFFF4F5F7);
  static const Color textDark = Color(0xFF111827);
  static const Color textGrey = Color(0xFF6B7280);

  @override
  void initState() {
    super.initState();
    _loadSettingData();
  }

  Future<void> _loadSettingData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await settingService.getMyProfile();

      if (!mounted) return;

      setState(() {
        user = result;
        showAchievementRank = result.shareLeaderboardStats;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _toggleAchievementRank(bool value) async {
    final oldValue = showAchievementRank;

    setState(() {
      showAchievementRank = value;
      errorMessage = null;
    });

    try {
      await settingService.updateShareLeaderboardStats(value);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        showAchievementRank = oldValue;
        errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> _logout() async {
    await settingService.logout();

    if (!mounted) return;

    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  String _displayName() {
    final data = user;

    if (data == null) return 'User';

    if (data.fullName.trim().isNotEmpty && data.fullName != 'User') {
      return data.fullName;
    }

    if (data.username.trim().isNotEmpty) {
      return data.username;
    }

    return 'User';
  }

  String _email() {
    return user?.email ?? '-';
  }

  String _initials() {
    final name = _displayName().trim();

    if (name.isEmpty || name == 'User') return 'U';

    final parts = name.split(' ').where((e) => e.isNotEmpty).toList();

    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }

    return name[0].toUpperCase();
  }

  Widget _buildHeader() {
    return Container(
      height: 104,
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 26,
      ),
      child: const Center(
        child: Text(
          'Pengaturan',
          style: TextStyle(
            color: textDark,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      width: double.infinity,
      height: 136,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: Color(0xFFE5E5E5),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: user?.avatarUrl == null || user!.avatarUrl!.isEmpty
                  ? Text(
                      _initials(),
                      style: const TextStyle(
                        color: Color(0xFF777777),
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    )
                  : ClipOval(
                      child: Image.network(
                        user!.avatarUrl!,
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return Text(
                            _initials(),
                            style: const TextStyle(
                              color: Color(0xFF777777),
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: isLoading
                ? const Text(
                    'Memuat...',
                    style: TextStyle(
                      color: textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _displayName(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: textDark,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _email(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: textDark,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF777777),
        fontSize: 17,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _preferenceTile() {
    return Container(
      width: double.infinity,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: primaryRed,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          const SizedBox(width: 17),
          const Expanded(
            child: Text(
              'Tampilkan Pencapaian & Peringkat',
              style: TextStyle(
                color: textDark,
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Transform.scale(
            scale: 0.78,
            child: Switch(
              value: showAchievementRank,
              activeColor: Colors.white,
              activeTrackColor: primaryRed,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: const Color(0xFF777777),
              onChanged: _toggleAchievementRank,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _logoutTile() {
    return InkWell(
      onTap: _logout,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: double.infinity,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: primaryRed,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Row(
          children: [
            SizedBox(width: 12),
            Icon(
              Icons.logout_rounded,
              color: primaryRed,
              size: 19,
            ),
            SizedBox(width: 22),
            Text(
              'Keluar',
              style: TextStyle(
                color: textDark,
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorBox() {
    if (errorMessage == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(
        errorMessage!,
        style: const TextStyle(
          color: primaryRed,
          fontSize: 12.5,
          height: 1.35,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 68, 32, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Preferensi'),
          const SizedBox(height: 10),
          _preferenceTile(),
          _errorBox(),
          const SizedBox(height: 28),
          _sectionTitle('Akun'),
          const SizedBox(height: 10),
          _logoutTile(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      body: RefreshIndicator(
        color: primaryRed,
        onRefresh: _loadSettingData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildHeader(),
              const Divider(
                height: 1,
                thickness: 1,
                color: Color(0xFFEDEDED),
              ),
              _buildProfileSection(),
              _buildContent(),
            ],
          ),
        ),
      ),
    );
  }
}
