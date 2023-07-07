import 'package:flutter/material.dart';
import 'package:todo_blitz/model/task.dart';
import 'package:todo_blitz/service/task_file_service.dart';

/// A class that represents a list of tasks.
class TaskStore extends ChangeNotifier {
  final List<Task> _tasks = [];
  late FileService _fileService;

  TaskStore(String filename) {
    _fileService = FileService(filename);

    // for (int i = 0; i < 10; i++) {
    //   _tasks.add(Task('Task $i', '', DateTime.now()));
    // }
    loadData();
  }

  Map<String, dynamic> toJson() {
    return {
      'tasks': _tasks.map((task) => task.toJson()).toList(),
    };
  }

  void loadData() async {
    Map<String, dynamic> json = await _fileService.readJson();
    List<dynamic> tasks = json['tasks'] ?? [];
    for (var task in tasks) {
      _tasks.add(Task.fromJson(task));
    }
  }

  void saveData() async {
    await _fileService.writeJson(toJson());
  }

  List<Task> getTasks() {
    return _tasks;
  }

  List<Task> getCompletedTasks() {
    return _tasks.where((task) => task.completed).toList();
  }

  List<Task> getIncompleteTasks() {
    return _tasks.where((task) => !task.completed).toList();
  }

  void addTask(Task task) {
    _tasks.insert(0, task);
    saveData();
  }

  bool removeTask(Task task) {
    bool removed = _tasks.remove(task);
    saveData();

    return removed;
  }

  void toggleTask(Task task) {
    task.toggleCompleted();
    saveData();
  }

  void clearCompletedTasks() {
    _tasks.removeWhere((task) => task.completed);
    saveData();
  }

  void clearAllTasks() {
    _tasks.clear();
    saveData();
  }

  @override
  String toString() {
    return _tasks.toString();
  }
}
