import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
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
  TodoListPageState() {
    ShakeDetector.autoStart(onPhoneShake: () {
      // TODO: FIX ROUTE
      if (ModalRoute.of(context)!.settings.name != '/') {
        return;
      }

      setState(() {
        showDialog(
          context: context,
          builder: (context) => DialogWidget(
            'title',
            'body',
            'rm_tasks',
            () {
              // TODO: get store from provider
              // Provider.of<TaskStore>(context, listen: false)
              // .clearCompletedTasks();
            },
          ),
        );
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  void _vibrate() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 150);
    } else {
      print('No Vibrator present 😭');
    }
  }

  void _playSound() {
    AudioPlayer().play(AssetSource('/audio/check.wav'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/config');
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
          ),
        ],
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
          taskForm(context),
          Expanded(
            child: taskList(context),
          ),
        ],
      ),
    );
  }

  Widget taskForm(BuildContext context) {
    TextEditingController controller = TextEditingController();
    TaskStore store = Provider.of<TaskStore>(context);

    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      SizedBox(
        width: 300,
        child: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Task Name',
          ),
        ),
      ),
      TextButton(
        onPressed: () {
          if (controller.text.trim().isEmpty) {
            // do nothing
            return;
          }

          setState(() {
            store.addTask(Task(controller.text, '', DateTime.now()));
            controller.clear();
          });
        },
        child: const Text('Add Task'),
      ),
    ]);
  }

  Widget taskList(BuildContext context) {
    TaskStore store = Provider.of<TaskStore>(context);

    return ReorderableListView(
      children: [
        for (int index = 0; index < store.getTasks().length; index++)
          listItem(context, index)
      ],
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final Task item = store.getTasks().removeAt(oldIndex);
          store.getTasks().insert(newIndex, item);
        });
      },
    );
  }

  Widget listItem(BuildContext context, index) {
    TaskStore store = Provider.of<TaskStore>(context);

    return Card(
      key: Key(store.getTasks()[index].uuid),
      color: store.getTasks()[index].completed
          ? const Color.fromARGB(255, 233, 233, 233)
          : const Color.fromARGB(255, 255, 255, 255),
      child: ListTile(
        // tileColor:
        leading: Checkbox(
          value: store.getTasks()[index].completed,
          onChanged: (value) {
            setState(
              () {
                store.getTasks()[index].completed = value!;

                if (value) {
                  _vibrate();
                  _playSound();
                }
              },
            );
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
        trailing:
            // child: Row(
            // children: [
            // store.getTasks()[index].date
            IconButton(
          onPressed: () {
            setState(() {
              store.removeTask(store.getTasks()[index]);
            });
          },
          alignment: Alignment.centerRight,
          icon: const Icon(Icons.delete),
        ),
        onTap: () async {
          await showModalBottomSheet(
            context: context,
            builder: (BuildContext context) =>
                TodoDetailPage(store.getTasks()[index]),
          );
          setState(() {});
        },
      ),
    );
  }
}

class DialogWidget extends StatelessWidget {
  final String id;
  final String title;
  final String body;
  final Function callback;

  static List<DialogWidget> dialogs = [];

  const DialogWidget(this.id, this.title, this.body, this.callback,
      {super.key});

  void _remove() {
    dialogs.remove(this);
  }

  static bool dialogExists(String id) {
    return dialogs.any((element) => element.id == id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(title),
          Text(body),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              callback();
              _remove();
            },
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _remove();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
