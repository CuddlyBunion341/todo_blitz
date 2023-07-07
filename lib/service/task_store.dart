import 'package:flutter/material.dart';
import 'package:todo_blitz/model/task.dart';
import 'package:todo_blitz/service/task_file_service.dart';

/// A class that represents a list of tasks.
class TaskStore extends ChangeNotifier {
  final List<Task> _tasks = [];

  void init() {
    for (int i = 0; i < 10; i++) {
      _tasks.add(Task('Task $i', '', DateTime.now(), false));
    }
  }

  TaskStore() {
    init();
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
  }

  bool removeTask(Task task) {
    return _tasks.remove(task);
  }

  void toggleTask(Task task) {
    task.toggleCompleted();
  }

  void clearCompletedTasks() {
    _tasks.removeWhere((task) => task.completed);
  }

  void clearAllTasks() {
    _tasks.clear();
  }

  @override
  String toString() {
    return _tasks.toString();
  }
}
