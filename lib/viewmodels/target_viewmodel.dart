import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/home_service.dart';

class TargetViewModel extends ChangeNotifier {
  final HomeService _homeService = HomeService();

  bool isLoading = false;
  String? errorMessage;
  String token = '';

  List<TaskModel> tasks = [];

  Future<void> loadTasks() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final savedToken = await _homeService.getSavedToken();

      if (savedToken == null || savedToken.isEmpty) {
        throw Exception('Token tidak ditemukan. Silakan login ulang.');
      }

      token = savedToken;
      tasks = await _homeService.getTasks(token);
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await loadTasks();
  }

  int get totalTasks => tasks.length;

  int get completedTasks => tasks.where((task) => task.isCompleted).length;

  double get progress {
    if (tasks.isEmpty) return 0;
    return completedTasks / totalTasks;
  }

  int get progressPercent => (progress * 100).toInt();

  List<TaskModel> get activeTasks =>
      tasks.where((task) => !task.isCompleted).toList();

  Future<void> addTask(TaskModel task) async {
    try {
      await _homeService.createTask(
        token: token,
        task: task,
      );
      await loadTasks();
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      rethrow;
    }
  }

  Future<void> toggleTask(int index, bool value) async {
    final oldValue = tasks[index].isCompleted;
    tasks[index].isCompleted = value;
    notifyListeners();

    try {
      await _homeService.updateTaskProgress(
        token: token,
        taskId: tasks[index].id,
        isCompleted: value,
      );
    } catch (e) {
      tasks[index].isCompleted = oldValue;
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    }
  }

  Future<void> removeTask(int index) async {
    final removedTask = tasks[index];
    tasks.removeAt(index);
    notifyListeners();

    try {
      await _homeService.deleteTask(
        token: token,
        taskId: removedTask.id,
      );
    } catch (e) {
      tasks.insert(index, removedTask);
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    }
  }
}
