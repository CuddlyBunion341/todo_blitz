import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:todo_blitz/pages/todo_list_page.dart';

import '../model/task.dart';

class TodoDetailPage extends StatefulWidget {
  Task task = Task('', '', DateTime.now());

  TodoDetailPage(this.task);

  @override
  State<StatefulWidget> createState() {
    return TodoDetailPageState(this.task);
  }
}

class TodoDetailPageState extends State<TodoDetailPage> {
  Task originalTask;
  Task editedTask = Task('', '', DateTime.now());
  TextEditingController titleController;
  TextEditingController contentController;

  TodoDetailPageState(this.originalTask)
      : titleController = TextEditingController(text: originalTask.title),
        contentController = TextEditingController(text: originalTask.content);

  @override
  void initState() {
    super.initState();
    editedTask = originalTask.clone();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: editedTask.date,
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
    );

    editedTask.date = picked!;
  }

  String _formatDate(DateTime date) {
    DateTime now = DateTime.now();
    return DateFormat.yMMMEd().format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Task Details'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
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
                minLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Task Description',
                ),
              ),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _selectDate(context);
                    });
                  },
                  child: const Text('Select Date')),
              Text('Date: ${_formatDate(editedTask.date)}'),
              Switch(
                value: editedTask.notify,
                onChanged: (bool value) {
                  setState(() {
                    editedTask.notify = value;
                  });
                },
              ),
              TextButton(
                onPressed: () {
                  // update task
                  originalTask.copy(editedTask);
                  Navigator.pop(
                      context, originalTask); // return to previous page
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
