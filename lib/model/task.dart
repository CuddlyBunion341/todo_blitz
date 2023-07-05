import 'package:uuid/uuid.dart';

/// A class that represents a task.
class Task {
  String uuid;
  String title;
  String content;
  DateTime date;
  bool completed;

  Task(
    this.title,
    this.content,
    this.date,
    this.completed,
  ) : uuid = const Uuid().v4();

  bool toggleCompleted() {
    completed = !completed;
    return completed;
  }

  bool isDue() {
    return date.isBefore(DateTime.now());
  }

  Task clone() {
    return Task(title, content, date, completed);
  }
}
