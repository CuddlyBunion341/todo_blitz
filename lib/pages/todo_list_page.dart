import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return TodoListPageState();
  }
}

class TodoListPageState extends State<TodoListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: Column(
        children: [
          const Text('Todo List'),
          // taskForm(),
          Expanded(
            child: taskList(),
          ),
        ],
      ),
    );
  }

  Widget taskForm() {
    TextEditingController controller = TextEditingController();

    return Row(children: [
      const Text('deine mom'),
      TextField(
        controller: controller,
        // decoration: const InputDecoration(
        //   hintText: 'Task Name',
        // ),
      ),
      TextButton(
        onPressed: () {
          // TODO: Add task
        },
        child: const Text('Add Task'),
      ),
    ]);
  }

  Widget taskList() {
    // Add the context parameter
    return ListView.builder(
        itemCount: 42,
        itemBuilder: (context, index) => listItem(context, index));
  }

  Widget listItem(BuildContext context, index) {
    return ListTile(
      title: Row(children: [
        Checkbox(
          value: Random().nextBool(),
          onChanged: (value) => {},
        ),
        Text('Taskfewjfiweji${index + 1}'),
      ]),
      onTap: () {
        Navigator.pushNamed(context, '/task_details');
      },
    );
  }
}
