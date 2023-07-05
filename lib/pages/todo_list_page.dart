import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shake/shake.dart';
import 'package:todo_blitz/pages/todo_detail_page.dart';
import 'package:vibration/vibration.dart';

import '../model/task.dart';
import '../service/task_store.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return TodoListPageState();
  }
}

class TodoListPageState extends State<TodoListPage> {
  TaskStore store = TaskStore();

  TodoListPageState() {
    ShakeDetector.autoStart(onPhoneShake: () {
      setState(() {
        // TODO: implement shake action
        store.addTask(Task('Dummy Task', 'Body', DateTime.now(), false));
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  void vibrate() async {
    // TODO: fix vibrations
    // if (await Vibration.hasVibrator()) {
    //   Vibration.vibrate();
    // }
    Vibration.vibrate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'TodoBlitz',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              Icons.bolt,
              color: Colors.white,
            )
          ],
        ),
      ),
      body: Column(
        children: [
          taskForm(),
          Expanded(
            child: taskList(store),
          ),
        ],
      ),
    );
  }

  Widget taskForm() {
    TextEditingController controller = TextEditingController();

    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      SizedBox(
        width: 200,
        child: TextField(
          controller: controller,
          // decoration: const InputDecoration(
          //   hintText: 'Task Name',
          // ),
        ),
      ),
      TextButton(
        onPressed: () {
          setState(() {
            store.addTask(Task(controller.text, '', DateTime.now(), false));
            controller.clear();
          });
        },
        child: const Text('Add Task'),
      ),
    ]);
  }

  Widget taskList(TaskStore store) {
    // Add the context parameter
    return ListView.builder(
        itemCount: store.getTasks().length,
        itemBuilder: (context, index) => listItem(context, index));
  }

  Widget listItem(BuildContext context, index) {
    return Card(
      // tileColor: Colors.black12,
      color: store.getTasks()[index].completed
          ? const Color.fromARGB(255, 233, 233, 233)
          : Colors.white,
      child: ListTile(
        // tileColor:
        leading: Checkbox(
          value: store.getTasks()[index].completed,
          onChanged: (value) => {
            setState(() {
              store.getTasks()[index].completed = value!;

              if (value) vibrate();
            })
          },
        ),
        title: Flexible(
          child: Text(
            store.getTasks()[index].title,
            style: TextStyle(
              decoration: store.getTasks()[index].completed
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
        ),
        trailing: IconButton(
          onPressed: () {
            setState(() {
              store.removeTask(store.getTasks()[index]);
            });
          },
          alignment: Alignment.centerRight,
          icon: const Icon(Icons.delete),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TodoDetailPage(store.getTasks()[index]),
            ),
          );
        },
      ),
    );
  }
}
