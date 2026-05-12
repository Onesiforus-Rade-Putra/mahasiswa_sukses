import 'package:flutter/material.dart';

import '../services/setting_service.dart';

class SettingViewModel extends ChangeNotifier {
  final SettingService _settingService = SettingService();

  bool isLoading = false;
  bool isUpdatingSetting = false;
  String? errorMessage;

  SettingUserModel? user;

  String name = 'User';
  String email = '-';

  bool showAchievementRank = false;

  Future<void> loadProfile() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await _settingService.getMyProfile();

      user = result;

      if (result.fullName.trim().isNotEmpty && result.fullName != 'User') {
        name = result.fullName;
      } else if (result.username.trim().isNotEmpty) {
        name = result.username;
      } else {
        name = 'User';
      }

      email = result.email;
      showAchievementRank = result.shareLeaderboardStats;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleAchievementRank(bool value) async {
    final oldValue = showAchievementRank;

    showAchievementRank = value;
    isUpdatingSetting = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _settingService.updateShareLeaderboardStats(value);
    } catch (e) {
      showAchievementRank = oldValue;
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isUpdatingSetting = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _settingService.logout();
  }

  String get displayName {
    if (name.trim().isNotEmpty) return name;
    return 'User';
  }

  String get displayEmail {
    if (email.trim().isNotEmpty) return email;
    return '-';
  }

  String get initials {
    final cleanName = displayName.trim();

    if (cleanName.isEmpty || cleanName == 'User') return 'U';

    final parts = cleanName.split(' ').where((e) => e.isNotEmpty).toList();

    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }

    return cleanName[0].toUpperCase();
  }

  void updateProfile({
    required String newName,
    required String newEmail,
  }) {
    name = newName;
    email = newEmail;
    notifyListeners();
  }
}
