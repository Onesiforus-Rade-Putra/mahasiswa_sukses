class HistoryModel {
  final int id;
  final String title;
  final int xpReward;
  final String type;
  final String completedAt;

  const HistoryModel({
    required this.id,
    required this.title,
    required this.xpReward,
    required this.type,
    required this.completedAt,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      xpReward: json['xp_reward'] ?? 0,
      type: json['type'] ?? '',
      completedAt: json['completed_at'] ?? '',
    );
  }
}
