import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_blitz/service/task_store.dart';

/// A class that represents the page that displays the settings.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  /// Builds the widget.
  @override
  Widget build(BuildContext context) {
    TaskStore tasks = Provider.of<TaskStore>(context);

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black, actions: const <Widget>[]),
      body: Column(
        children: <Widget>[
          const Text('Reminders'),
          ListTile(
            leading: const Text('Allow notifications'),
            trailing: Checkbox(
              value: false,
              onChanged: (value) {
                // TODO: Implement this
              },
            ),
          ),
          const Text('Stats:'),
          Text('Total tasks: ${tasks.getTasks().length}'), // TODO: Fix this
          Text('Total completed: ${tasks.getCompletedTasks().length}'),
          Text('Total unchecked: ${tasks.getIncompleteTasks().length}'),
          const Text('Notifications sent: TODO'),
        ],
      ),
    );
  }
}
