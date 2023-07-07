import 'package:uuid/uuid.dart';

/// A class that represents a task.
class Task {
  String uuid;
  String title;
  String content;
  DateTime date;
  bool completed;
  bool notify;

  Task(this.title, this.content, this.date,
      {this.notify = false, this.completed = false})
      : uuid = const Uuid().v4();

  Task.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        title = json['title'],
        content = json['content'],
        date = DateTime.parse(json['date']),
        completed = json['completed'] == 'true',
        notify = json['notify'] == 'true';

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

  bool isDue() {
    return date.isBefore(DateTime.now());
  }

  Task clone() {
    Task task = Task(title, content, date, completed: completed);
    task.uuid = uuid;
    return task;
  }

  void copy(Task task) {
    uuid = task.uuid;
    title = task.title;
    content = task.content;
    date = task.date;
    completed = task.completed;
  }
}
