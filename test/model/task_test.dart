import 'package:todo_blitz/model/task.dart';
import 'package:test/test.dart';

void main() {
  test('Empty task', () {
    DateTime date = DateTime.now();
    final task = Task('', '', date);
    expect(task.title, '');
    expect(task.content, '');
    expect(task.date, date);
    expect(task.completed, false);
  });

  test('Toggle completed', () {
    final task = Task('', '', DateTime.now());
    expect(task.completed, false);
    task.toggleCompleted();
    expect(task.completed, true);
    task.toggleCompleted();
    expect(task.completed, false);
  });

  test('isDue() returns true when date is before now', () {
    final task = Task('', '', DateTime(2000));
    expect(task.isDue(), true);

    final task2 = Task('', '', DateTime.now());
    expect(task2.isDue(), false);
  });
}
