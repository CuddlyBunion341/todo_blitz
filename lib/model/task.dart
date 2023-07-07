import 'package:uuid/uuid.dart';

/// A class that represents a task.
class Task {
  String uuid;
  String title;
  String content;
  DateTime date;
  bool completed;
  bool notify;

  /// Creates a task.
  Task(this.title, this.content, this.date,
      {this.notify = false, this.completed = false})
      : uuid = const Uuid().v4();

  /// Creates a task from a JSON object.
  Task.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        title = json['title'],
        content = json['content'],
        date = DateTime.parse(json['date']),
        completed = json['completed'] == 'true',
        notify = json['notify'] == 'true';

  /// Converts this task to a JSON object.
  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'title': title,
        'content': content,
        'date': date.toString(),
        'completed': completed,
        'notify': notify,
      };

  bool toggleCompleted() {
    completed = !completed;
    return completed;
  }

  /// Returns true if the task is due. Returns false if the task is past due.
  bool isDue() {
    return date.isBefore(DateTime.now());
  }

  /// Returns true if the task is past due. Returns false if the task is due.
  bool isOverdue() {
    return !isDue() && !completed;
  }

  /// Returns a clone of this task.
  Task clone() {
    Task task =
        Task(title, content, date, completed: completed, notify: notify);
    task.uuid = uuid;
    return task;
  }

  /// Copies the values of the given task to this task.
  void copy(Task task) {
    uuid = task.uuid;
    title = task.title;
    content = task.content;
    date = task.date;
    completed = task.completed;
    notify = task.notify;
  }

  /// Returns a string representation of this object. (used for debugging)
  @override
  String toString() {
    return 'Task{uuid: $uuid, title: $title, content: $content, date: $date, completed: $completed, notify: $notify}';
  }
}
