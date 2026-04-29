class StudyRoomModel {
  final String id;
  final String authorName;
  final String authorInitial;
  final String title;
  final String description;
  final int currentParticipants;
  final int maxParticipants;
  final int likes;
  final String timeAgo;

  StudyRoomModel({
    required this.id,
    required this.authorName,
    required this.authorInitial,
    required this.title,
    required this.description,
    required this.currentParticipants,
    required this.maxParticipants,
    required this.likes,
    required this.timeAgo,
  });
}
