import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(backgroundColor: Colors.black, actions: const <Widget>[]),
        body: Column(
          children: <Widget>[
            const Text('Stats:'),
            const Text('Total tasks: \${0}'),
            const Text('Total completed: \${0}'),
            const Text('Total unchecked: \${0}'),
            const Text('Notifications sent: \${0}'),
            const Text('CSV Actions'),
            TextButton(
              onPressed: () {},
              child: const Text('Export Tasks CSV'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Import Tasks CSV'),
            ),
            const Text('JSON Actions'),
            TextButton(
              onPressed: () {},
              child: const Text('Export Tasks JSON'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Import Tasks JSON'),
            ),
          ],
        ));
  }
}
