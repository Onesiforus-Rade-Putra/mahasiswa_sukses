class TaskModel {
  final String title;
  final String description;
  final String category;
  final String priority;
  final String date;
  bool isCompleted;

  TaskModel({
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.date,
    this.isCompleted = false,
  });
}
