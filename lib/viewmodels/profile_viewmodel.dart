import 'package:flutter/material.dart';

import '../models/achievement_model.dart';
import '../models/friend_model.dart';
import '../models/user_profile_model.dart';
import '../services/achievement_service.dart';
import '../services/profile_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();
  final AchievementService _achievementService = AchievementService();

  bool isLoading = false;
  bool isActionLoading = false;
  String? errorMessage;

  UserProfileModel? profile;
  FriendSummaryModel friendSummary = const FriendSummaryModel.empty();
  List<FriendModel> friends = [];
  List<FriendModel> friendRequests = [];
  AchievementModel? achievementData;

  Future<void> loadProfilePage() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      profile = await _profileService.getMyProfile();

      try {
        friendSummary = await _profileService.getFriendSummary();
      } catch (_) {}

      try {
        friends = await _profileService.getFriends();
      } catch (_) {}

      try {
        friendRequests = await _profileService.getFriendRequests();
      } catch (_) {}

      try {
        achievementData = await _achievementService.getAchievementData();
      } catch (_) {}
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await loadProfilePage();
  }

  Future<void> addFriend(String emailOrUsername) async {
    final target = emailOrUsername.trim();

    if (target.isEmpty) {
      errorMessage = 'Username wajib diisi';
      notifyListeners();
      return;
    }

    if (target.length < 3) {
      errorMessage = 'Username minimal 3 karakter';
      notifyListeners();
      return;
    }

    isActionLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _profileService.sendFriendRequest(target);

      errorMessage = null;

      try {
        friendSummary = await _profileService.getFriendSummary();
      } catch (_) {}

      try {
        friends = await _profileService.getFriends();
      } catch (_) {}

      try {
        friendRequests = await _profileService.getFriendRequests();
      } catch (_) {}
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isActionLoading = false;
      notifyListeners();
    }
  }

  Future<void> acceptFriend(String requesterId) async {
    isActionLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _profileService.acceptFriend(requesterId);
      await loadProfilePage();
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isActionLoading = false;
      notifyListeners();
    }
  }

  Future<void> denyFriend(String requesterId) async {
    isActionLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _profileService.denyFriend(requesterId);
      await loadProfilePage();
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isActionLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeFriend(String friendId) async {
    isActionLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _profileService.removeFriend(friendId);
      await loadProfilePage();
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isActionLoading = false;
      notifyListeners();
    }
  }

  String get username => profile?.displayUsername ?? 'username';

  String get name => profile?.displayName ?? 'Mahasiswa';

  String get description {
    final text = profile?.description?.trim();

    if (text != null && text.isNotEmpty) {
      return text;
    }

    return 'Passionate learner yang suka tantangan baru dan terus berkembang!';
  }

  int get level {
    final fromProfile = profile?.currentLevel ?? 0;
    final fromAchievement = achievementData?.summary.currentLevel ?? 0;

    return fromProfile > 0 ? fromProfile : fromAchievement;
  }

  int get totalXp {
    final fromProfile = profile?.totalXp ?? 0;
    final fromAchievement = achievementData?.summary.currentPoint ?? 0;

    return fromProfile > 0 ? fromProfile : fromAchievement;
  }

  int get friendCount {
    if (friendSummary.friendCount > 0) {
      return friendSummary.friendCount;
    }

    return friends.length;
  }

  int get friendRequestCount {
    if (friendSummary.friendRequestCount > 0) {
      return friendSummary.friendRequestCount;
    }

    return friendRequests.length;
  }

  int get achievedCount => achievementData?.summary.achieved ?? 0;

  int get totalAchievement => achievementData?.summary.totalAchievement ?? 15;

  double get achievementProgress {
    if (totalAchievement <= 0) return 0;

    return (achievedCount / totalAchievement).clamp(0.0, 1.0);
  }

  int get nextLevel => level + 1;

  int get nextLevelTarget {
    if (totalXp <= 0) return 1000;

    final nextTarget = ((totalXp ~/ 1000) + 1) * 1000;

    return nextTarget <= totalXp ? totalXp + 1000 : nextTarget;
  }

  double get levelProgress {
    if (nextLevelTarget <= 0) return 0;

    return (totalXp / nextLevelTarget).clamp(0.0, 1.0);
  }

  int get remainingXp {
    final remaining = nextLevelTarget - totalXp;

    return remaining < 0 ? 0 : remaining;
  }

  Future<String?> sendFriendRequestForDialog(String emailOrUsername) async {
    final target = emailOrUsername.trim();

    if (target.isEmpty) {
      return 'Username wajib diisi';
    }

    if (target.length < 3) {
      return 'Username minimal 3 karakter';
    }

    try {
      await _profileService.sendFriendRequest(target);
      return null;
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }
  }

  Future<void> reloadFriendSection() async {
    try {
      friendSummary = await _profileService.getFriendSummary();
    } catch (_) {}

    try {
      friends = await _profileService.getFriends();
    } catch (_) {}

    try {
      friendRequests = await _profileService.getFriendRequests();
    } catch (_) {}

    notifyListeners();
  }
}
