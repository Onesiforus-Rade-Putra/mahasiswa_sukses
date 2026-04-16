import '../models/task_model.dart';

class TargetViewModel {
  final List<TaskModel> tasks = [
    TaskModel(
      title: 'Tugas Besar Kalkulus',
      description: 'Selesaikan soal bab 4-5 dan buat laporan.',
      category: 'Akademik',
      priority: 'Tinggi',
      date: '12 Feb 2026, 20:04',
    ),
    TaskModel(
      title: 'Rapat Divisi Acara',
      description: 'Briefing untuk event bulan depan.',
      category: 'Pribadi',
      priority: 'Sedang',
      date: '12 Feb 2026, 20:04',
    ),
    TaskModel(
      title: 'Beli Buku Catatan',
      description: '',
      category: 'Organisasi',
      priority: 'Sedang',
      date: '12 Feb 2026, 20:04',
    ),
  ];

  int get totalTasks => tasks.length;

  int get completedTasks => tasks.where((task) => task.isCompleted).length;

  double get progress {
    if (tasks.isEmpty) return 0;
    return completedTasks / totalTasks;
  }

  int get progressPercent => (progress * 100).toInt();

  void addTask(TaskModel task) {
    tasks.add(task);
  }

  void removeTask(int index) {
    tasks.removeAt(index);
  }

  void toggleTask(int index, bool value) {
    tasks[index].isCompleted = value;
  }
}
