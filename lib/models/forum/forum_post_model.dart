class ForumPostModel {
  final String id;
  final String authorName;
  final String authorInitial;
  final String category;
  final String title;
  final String description;
  final List<String> tags;
  final int likes;
  final int comments;
  final String timeAgo;

  ForumPostModel({
    required this.id,
    required this.authorName,
    required this.authorInitial,
    required this.category,
    required this.title,
    required this.description,
    required this.tags,
    required this.likes,
    required this.comments,
    required this.timeAgo,
  });
}
