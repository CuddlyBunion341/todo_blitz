import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shake/shake.dart';
import 'package:todo_blitz/pages/todo_detail_page.dart';
import 'package:vibration/vibration.dart';

import '../model/task.dart';
import '../service/task_store.dart';
import '../widgets/dialogue.dart';

/// A class that represents the page that displays the list of tasks.
class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return TodoListPageState();
  }
}

/// State for [TodoListPage].
class TodoListPageState extends State<TodoListPage> {
  TodoListPageState() {
    ShakeDetector.autoStart(onPhoneShake: () {
      // TODO: fix shaker
      if (ModalRoute.of(context)!.settings.name != '/') {
        return;
      }

      TaskStore store = Provider.of<TaskStore>(context, listen: false);

      if (DialogWidget.dialogExists('rm_tasks')) return;
      if (store.getCompletedTasks().isEmpty) return;

      showDialog(
        context: context,
        builder: (context) => DialogWidget(
          'rm_tasks',
          'Clear completed tasks',
          'All completed Todo-Tasks will be deleted, this action is not undoable!',
          () {
            setState(() {
              store.clearCompletedTasks();
            });
          },
        ),
      );
    });
  }

  /// Initializes the state of this widget.
  @override
  void initState() {
    super.initState();
  }

  /// Disposes of this widget.
  @override
  void dispose() {
    super.dispose();
    Vibration.cancel();
    // TODO: dispose ShakeDetector
    // TODO: displose AudioPlayer
  }

  /// Vibrates the device for 150 milliseconds.
  void _vibrate() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 150);
    } else {
      print('No Vibrator present 😭');
    }
  }

  /// Plays a check sound.
  void _playSound() {
    AudioPlayer().play(AssetSource('/audio/check.wav'));
  }

  /// Builds the app bar.
  AppBar _appBar() {
    return AppBar(
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
    );
  }

  /// Builds the widget.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          _taskForm(context),
          // _taskList(context),
          Expanded(
            child: _taskList(context),
          ),
        ],
      ),
    );
  }

  /// Builds the task form.
  Widget _taskForm(BuildContext context) {
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

  /// Builds the task list.
  Widget _taskList(BuildContext context) {
    TaskStore store = Provider.of<TaskStore>(context);

    if (store.getTasks().isEmpty) {
      return const Center(
        child: Text('No Tasks'),
      );
    }

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

  /// Builds a list item. (task)
  Widget listItem(BuildContext context, index) {
    TaskStore store = Provider.of<TaskStore>(context);

    Task task = store.getTasks()[index];

    return Card(
      key: Key(task.uuid),
      color: task.completed
          ? const Color.fromARGB(255, 233, 233, 233)
          : const Color.fromARGB(255, 255, 255, 255),
      child: ListTile(
        // tileColor: Color.fromARGB(255, 255, 255, 255),
        leading: Checkbox(
          value: task.completed,
          onChanged: (value) {
            setState(
              () {
                task.completed = value!;
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
            task.title,
            style: TextStyle(
              decoration: task.completed
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
        ),
        trailing: IconButton(
          onPressed: () {
            setState(() {
              store.removeTask(task);
            });
          },
          alignment: Alignment.centerRight,
          icon: const Icon(Icons.delete),
        ),
        onTap: () async {
          await showModalBottomSheet(
            context: context,
            builder: (BuildContext context) => TodoDetailPage(task),
          );
          setState(() {
            // update state to refresh the list
          });
        },
      ),
    );
  }
}
