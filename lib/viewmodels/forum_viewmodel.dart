import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/forum/chat_message_model.dart';
import '../models/forum/forum_post_model.dart';
import '../models/forum/study_room_model.dart';
import '../services/forum_service.dart';
import '../models/forum/forum_comment_model.dart';

class ForumViewModel extends ChangeNotifier {
  final ForumService _forumService = ForumService();

  bool _isDisposed = false;

  bool isLoading = false;
  bool isActionLoading = false;
  String? errorMessage;

  int onlineCount = 0;
  int activeRoomsCount = 0;

  String selectedCategory = 'Semua';
  String roomSearchQuery = '';

  String? currentUserId;
  String? currentUsername;

  final List<String> categories = [
    'Semua',
    'Umum',
    'Tips & Trik',
    'Bantuan',
  ];

  List<ForumPostModel> posts = [];
  List<StudyRoomModel> studyRooms = [];
  List<ChatMessageModel> chatMessages = [];

  List<ForumPostModel> get filteredPosts => posts;

  List<ForumCommentModel> postComments = [];

  String get onlineText {
    if (onlineCount <= 0) {
      return '0 mahasiswa online';
    }

    return '$onlineCount mahasiswa online';
  }

  String get activeRoomText {
    if (activeRoomsCount <= 0) {
      return '0 ruang aktif';
    }

    return '$activeRoomsCount ruang aktif';
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

  int _toInt(dynamic value, {int defaultValue = 0}) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? defaultValue;
  }

  DateTime _readDate(dynamic value) {
    return DateTime.tryParse(value?.toString() ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0);
  }

  void _setLoading(bool value) {
    isLoading = value;
    safeNotifyListeners();
  }

  void _setActionLoading(bool value) {
    isActionLoading = value;
    safeNotifyListeners();
  }

  Future<void> initForum() async {
    errorMessage = null;
    _setLoading(true);

    try {
      await Future.wait([
        fetchCommunityStats(notify: false),
        fetchForumFeed(notify: false),
      ]);
    } catch (e) {
      errorMessage = e.toString();
    }

    _setLoading(false);
  }

  Future<void> initStudyRooms() async {
    errorMessage = null;
    _setLoading(true);

    try {
      await Future.wait([
        fetchCommunityStats(notify: false),
        fetchRoomFeed(notify: false),
      ]);
    } catch (e) {
      errorMessage = e.toString();
    }

    _setLoading(false);
  }

  Future<void> initChatRoom(int roomId) async {
    errorMessage = null;
    _setLoading(true);

    try {
      await loadCurrentUser();
      await fetchChatHistory(roomId, notify: false);
    } catch (e) {
      errorMessage = e.toString();
    }

    _setLoading(false);
  }

  Future<void> fetchCommunityStats({bool notify = true}) async {
    try {
      final data = await _forumService.getCommunityStats();

      onlineCount = _toInt(data['online_count']);
      activeRoomsCount = _toInt(data['active_rooms_count']);

      if (notify) safeNotifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      if (notify) safeNotifyListeners();
      rethrow;
    }
  }

  Future<void> fetchForumFeed({bool notify = true}) async {
    try {
      final data = await _forumService.getForumFeed(
        category: selectedCategory,
      );

      posts = data
          .whereType<Map<String, dynamic>>()
          .map((json) => ForumPostModel.fromJson(json))
          .toList();

      if (notify) safeNotifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      if (notify) safeNotifyListeners();
      rethrow;
    }
  }

  Future<void> fetchRoomFeed({
    String? query,
    bool notify = true,
  }) async {
    try {
      final keyword = query ?? roomSearchQuery;

      final data = await _forumService.getRoomFeed(
        query: keyword,
      );

      studyRooms = data
          .whereType<Map<String, dynamic>>()
          .map((json) => StudyRoomModel.fromJson(json))
          .toList();

      if (notify) safeNotifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      if (notify) safeNotifyListeners();
      rethrow;
    }
  }

  Future<void> changeCategory(String category) async {
    selectedCategory = category;
    errorMessage = null;
    _setLoading(true);

    try {
      await fetchForumFeed(notify: false);
    } catch (e) {
      errorMessage = e.toString();
    }

    _setLoading(false);
  }

  Future<void> searchRooms(String query) async {
    roomSearchQuery = query.trim();
    errorMessage = null;
    _setLoading(true);

    try {
      await fetchRoomFeed(
        query: roomSearchQuery,
        notify: false,
      );
    } catch (e) {
      errorMessage = e.toString();
    }

    _setLoading(false);
  }

  Future<bool> createPost({
    required String title,
    required String content,
    required String category,
    required List<String> tags,
  }) async {
    final cleanTitle = title.trim();
    final cleanContent = content.trim();

    errorMessage = null;

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

    _setActionLoading(true);

    try {
      await _forumService.createPost(
        title: cleanTitle,
        content: cleanContent,
        category: category,
        tags: tags
            .map((tag) => tag.trim())
            .where((tag) => tag.isNotEmpty)
            .toList(),
      );

      await fetchForumFeed(notify: false);
      _setActionLoading(false);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      _setActionLoading(false);
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

    errorMessage = null;

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

    _setActionLoading(true);

    try {
      await _forumService.createRoom(
        title: cleanTitle,
        description: cleanDescription,
        maxParticipants: maxParticipants,
      );

      await fetchRoomFeed(notify: false);
      _setActionLoading(false);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      _setActionLoading(false);
      return false;
    }
  }

  Future<bool> joinRoom(int roomId) async {
    errorMessage = null;
    _setActionLoading(true);

    try {
      await _forumService.joinStudyRoom(roomId);

      await fetchRoomFeed(notify: false);

      _setActionLoading(false);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      _setActionLoading(false);
      return false;
    }
  }

  Future<bool> leaveRoom(int roomId) async {
    errorMessage = null;
    _setActionLoading(true);

    try {
      await _forumService.leaveStudyRoom(roomId);

      await fetchRoomFeed(notify: false);

      _setActionLoading(false);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      _setActionLoading(false);
      return false;
    }
  }

  Future<void> fetchChatHistory(
    int roomId, {
    bool notify = true,
  }) async {
    try {
      final data = await _forumService.getChatHistory(
        roomId: roomId,
      );

      final rawMessages = data.whereType<Map<String, dynamic>>().toList();

      rawMessages.sort((a, b) {
        final dateA = DateTime.tryParse(a['created_at']?.toString() ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0);
        final dateB = DateTime.tryParse(b['created_at']?.toString() ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0);

        return dateB.compareTo(dateA);
      });

      chatMessages = rawMessages
          .map(
            (json) => ChatMessageModel.fromJson(
              json,
              currentUsername: currentUsername,
              currentUserId: currentUserId,
            ),
          )
          .toList();

      if (notify) safeNotifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      if (notify) safeNotifyListeners();
      rethrow;
    }
  }

  Future<bool> sendMessage({
    required int roomId,
    required String message,
    int? replyingTo,
  }) async {
    final text = message.trim();

    errorMessage = null;

    if (text.isEmpty) {
      errorMessage = 'Pesan tidak boleh kosong';
      safeNotifyListeners();
      return false;
    }

    _setActionLoading(true);

    try {
      await _forumService.sendChatMessage(
        roomId: roomId,
        content: text,
        replyingTo: replyingTo,
      );

      await fetchChatHistory(
        roomId,
        notify: false,
      );

      _setActionLoading(false);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      _setActionLoading(false);
      return false;
    }
  }

  Future<void> togglePostLike(int postId) async {
    errorMessage = null;

    try {
      await _forumService.togglePostLike(postId);
      await fetchForumFeed(notify: false);
      safeNotifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      safeNotifyListeners();
    }
  }

  Future<void> toggleRoomLike(int roomId) async {
    errorMessage = null;

    try {
      await _forumService.toggleRoomLike(roomId: roomId);
      await fetchRoomFeed(notify: false);
      safeNotifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      safeNotifyListeners();
    }
  }

  Future<void> toggleRoomChatLike({
    required int roomId,
    required int roomMessageId,
  }) async {
    errorMessage = null;

    try {
      await _forumService.toggleRoomChatLike(
        roomMessageId: roomMessageId,
      );

      await fetchChatHistory(
        roomId,
        notify: false,
      );

      safeNotifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      safeNotifyListeners();
    }
  }

  Future<void> loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();

    currentUsername = prefs.getString('username') ??
        prefs.getString('current_login_identifier') ??
        prefs.getString('email_or_username');

    currentUserId = prefs.getString('user_id') ??
        prefs.getString('userId') ??
        prefs.getString('id');

    debugPrint('CURRENT USERNAME: $currentUsername');
    debugPrint('CURRENT USER ID: $currentUserId');
  }

  bool isMyMessage(ChatMessageModel message) {
    if (currentUserId != null &&
        currentUserId!.isNotEmpty &&
        message.authorId.toString() == currentUserId.toString()) {
      return true;
    }

    if (currentUsername != null &&
        currentUsername!.isNotEmpty &&
        message.authorUsername.toLowerCase() ==
            currentUsername!.toLowerCase()) {
      return true;
    }

    return false;
  }

  Future<void> fetchPostComments(
    int postId, {
    bool notify = true,
  }) async {
    try {
      final data = await _forumService.getPostComments(postId);

      postComments = data
          .whereType<Map<String, dynamic>>()
          .map((json) => ForumCommentModel.fromJson(json))
          .toList();

      if (notify) safeNotifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      if (notify) safeNotifyListeners();
      rethrow;
    }
  }

  Future<bool> sendPostComment({
    required int postId,
    required String comment,
  }) async {
    final cleanComment = comment.trim();

    errorMessage = null;

    if (cleanComment.isEmpty) {
      errorMessage = 'Komentar tidak boleh kosong';
      safeNotifyListeners();
      return false;
    }

    _setActionLoading(true);

    try {
      await _forumService.commentOnPost(
        postId: postId,
        comment: cleanComment,
      );

      await fetchPostComments(
        postId,
        notify: false,
      );

      _setActionLoading(false);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      _setActionLoading(false);
      return false;
    }
  }
}
