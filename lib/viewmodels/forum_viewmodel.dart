import 'package:flutter/material.dart';

import '../models/forum/forum_post_model.dart';
import '../models/forum/study_room_model.dart';
import '../models/forum/chat_message_model.dart';
import '../services/forum_service.dart';

class ForumViewModel extends ChangeNotifier {
  final ForumService _forumService = ForumService();

  bool _isDisposed = false;

  bool isLoading = false;
  String? errorMessage;

  int onlineCount = 0;
  int activeRoomsCount = 0;

  String selectedCategory = 'Semua';

  final List<String> categories = [
    'Semua',
    'Umum',
    'Tips & Trik',
    'Bantuan',
  ];

  List<ForumPostModel> posts = [];
  List<StudyRoomModel> studyRooms = [];
  List<ChatMessageModel> chatMessages = [];

  List<ForumPostModel> get filteredPosts {
    return posts;
  }

  void safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> initForum() async {
    isLoading = true;
    errorMessage = null;
    safeNotifyListeners();

    try {
      await Future.wait([
        fetchCommunityStats(),
        fetchForumFeed(),
      ]);
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    safeNotifyListeners();
  }

  Future<void> initStudyRooms() async {
    isLoading = true;
    errorMessage = null;
    safeNotifyListeners();

    try {
      await Future.wait([
        fetchCommunityStats(),
        fetchRoomFeed(),
      ]);
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    safeNotifyListeners();
  }

  Future<void> fetchCommunityStats() async {
    final data = await _forumService.getCommunityStats();

    onlineCount = data['online_count'] is int ? data['online_count'] : 0;
    activeRoomsCount =
        data['active_rooms_count'] is int ? data['active_rooms_count'] : 0;
  }

  Future<void> fetchForumFeed() async {
    final data = await _forumService.getForumFeed(
      category: selectedCategory,
    );

    posts = data
        .whereType<Map<String, dynamic>>()
        .map((json) => ForumPostModel.fromJson(json))
        .toList();
  }

  Future<void> fetchRoomFeed() async {
    final data = await _forumService.getRoomFeed();

    studyRooms = data
        .whereType<Map<String, dynamic>>()
        .map((json) => StudyRoomModel.fromJson(json))
        .toList();
  }

  Future<void> changeCategory(String category) async {
    selectedCategory = category;

    isLoading = true;
    errorMessage = null;
    safeNotifyListeners();

    try {
      await fetchForumFeed();
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    safeNotifyListeners();
  }

  Future<bool> joinRoom(int roomId) async {
    errorMessage = null;
    safeNotifyListeners();

    try {
      await _forumService.joinStudyRoom(roomId);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      safeNotifyListeners();
      return false;
    }
  }

  Future<void> initChatRoom(int roomId) async {
    isLoading = true;
    errorMessage = null;
    safeNotifyListeners();

    try {
      await fetchChatHistory(roomId);
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    safeNotifyListeners();
  }

  Future<void> fetchChatHistory(int roomId) async {
    final data = await _forumService.getChatHistory(roomId);

    for (final item in data) {
      debugPrint('CHAT ITEM: $item');
    }

    chatMessages = data
        .whereType<Map<String, dynamic>>()
        .map((json) => ChatMessageModel.fromJson(json))
        .toList();
  }

  Future<bool> sendMessage({
    required int roomId,
    required String message,
  }) async {
    final text = message.trim();

    if (text.isEmpty) {
      errorMessage = 'Pesan tidak boleh kosong';
      safeNotifyListeners();
      return false;
    }

    try {
      await _forumService.sendChatMessage(
        roomId: roomId,
        content: text,
      );

      await fetchChatHistory(roomId);
      safeNotifyListeners();

      return true;
    } catch (e) {
      errorMessage = e.toString();
      safeNotifyListeners();

      return false;
    }
  }

  Future<bool> createPost({
    required String title,
    required String content,
    required String category,
    required List<String> tags,
  }) async {
    final cleanTitle = title.trim();
    final cleanContent = content.trim();

    if (cleanTitle.isEmpty) {
      errorMessage = 'Judul postingan wajib diisi';
      safeNotifyListeners();
      return false;
    }

    if (cleanContent.isEmpty) {
      errorMessage = 'Isi postingan wajib diisi';
      safeNotifyListeners();
      return false;
    }

    try {
      await _forumService.createPost(
        title: cleanTitle,
        content: cleanContent,
        category: _mapCategoryToApi(category),
        tags: tags,
      );

      await fetchForumFeed();
      safeNotifyListeners();

      return true;
    } catch (e) {
      errorMessage = e.toString();
      safeNotifyListeners();
      return false;
    }
  }

  Future<bool> createRoom({
    required String title,
    required String description,
    required int maxParticipants,
  }) async {
    final cleanTitle = title.trim();
    final cleanDescription = description.trim();

    if (cleanTitle.isEmpty) {
      errorMessage = 'Judul ruang belajar wajib diisi';
      safeNotifyListeners();
      return false;
    }

    if (cleanDescription.isEmpty) {
      errorMessage = 'Isi ruang belajar wajib diisi';
      safeNotifyListeners();
      return false;
    }

    if (maxParticipants < 1 || maxParticipants > 20) {
      errorMessage = 'Maksimal peserta harus 1 sampai 20';
      safeNotifyListeners();
      return false;
    }

    try {
      await _forumService.createRoom(
        title: cleanTitle,
        description: cleanDescription,
        maxParticipants: maxParticipants,
      );

      await fetchRoomFeed();
      safeNotifyListeners();

      return true;
    } catch (e) {
      errorMessage = e.toString();
      safeNotifyListeners();
      return false;
    }
  }

  String _mapCategoryToApi(String category) {
    switch (category) {
      case 'Umum':
        return 'umum';
      case 'Tips & trik':
      case 'Tips & Trik':
        return 'tips_trik';
      case 'Bantuan':
        return 'bantuan';
      default:
        return 'umum';
    }
  }

  Future<void> toggleRoomLike(int roomId) async {
    try {
      await _forumService.toggleRoomLike(roomId: roomId);
      await fetchRoomFeed();
      safeNotifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      safeNotifyListeners();
    }
  }

  Future<bool> leaveRoom(int roomId) async {
    try {
      await _forumService.leaveStudyRoom(roomId);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      safeNotifyListeners();
      return false;
    }
  }
}
