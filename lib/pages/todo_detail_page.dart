import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:todo_blitz/pages/todo_list_page.dart';

import '../model/task.dart';

class TodoDetailPage extends StatefulWidget {
  Task task = Task('', '', DateTime.now(), false);

  TodoDetailPage(Task task, {super.key}) {
    this.task = task.clone();
  }

  @override
  State<StatefulWidget> createState() {
    return TodoDetailPageState(task);
  }
}

class TodoDetailPageState extends State<TodoDetailPage> {
  Task task;

  TodoDetailPageState(this.task);

  @override
  void initState() {
    super.initState();
    task = task.clone();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: task.date,
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
    );

    task.date = picked!;
  }

  String _formatDate(DateTime date) {
    DateTime now = DateTime.now();
    return DateFormat.yMMMEd().format(now);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController =
        TextEditingController(text: task.title);
    TextEditingController contentController =
        TextEditingController(text: task.content);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Task Name',
              ),
            ),
            TextField(
              controller: contentController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    _selectDate(context);
                  });
                },
                child: const Text('Select Date')),
            Text('Date: ${_formatDate(task.date)}'),
            TextButton(
                onPressed: () {
                  // update task
                  task.title = titleController.text;
                  task.content = contentController.text;
                  Navigator.pop(context, task); // return to previous page
                },
                child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
