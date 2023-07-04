import 'package:todo_blitz/model/task.dart';

/// A class that represents a list of tasks.
class TaskStore {
  final List<Task> _tasks = [];

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
    _tasks.add(task);
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
