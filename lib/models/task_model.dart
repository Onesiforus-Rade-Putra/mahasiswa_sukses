class TaskModel {
  final int id;
  final String title;
  final String category;
  final String priority;
  final String deadline;
  final String? rawDescription;
  bool isCompleted;

  TaskModel({
    this.id = 0,
    required this.title,
    required this.category,
    required this.priority,
    required this.deadline,
    this.rawDescription,
    this.isCompleted = false,
  });

  /// Supaya kode lama `task.description` tetap jalan
  String get description => rawDescription ?? '';

  /// Supaya kode lama `task.date` tetap jalan
  String get date => deadline;

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      category: _normalizeCategory(json['category'] ?? ''),
      priority: _normalizePriority(json['priority'] ?? ''),
      deadline: json['deadline'] ?? '',
      rawDescription: json['description'],
      isCompleted: json['is_completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'priority': priority,
      'deadline': deadline,
      'description': rawDescription,
      'is_completed': isCompleted,
    };
  }

  static String _normalizeCategory(String value) {
    switch (value.toLowerCase()) {
      case 'akademik':
        return 'Akademik';
      case 'pribadi':
        return 'Pribadi';
      case 'organisasi':
        return 'Organisasi';
      default:
        return value;
    }
  }

  static String _normalizePriority(String value) {
    switch (value.toLowerCase()) {
      case 'tinggi':
        return 'Tinggi';
      case 'sedang':
        return 'Sedang';
      case 'rendah':
        return 'Rendah';
      default:
        return value;
    }
  }
}
