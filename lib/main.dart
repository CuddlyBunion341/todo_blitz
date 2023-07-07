import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_blitz/pages/settings_page.dart';
import 'package:todo_blitz/pages/todo_list_page.dart';
import 'package:todo_blitz/service/task_store.dart';

void main() {
  runApp(const TodoBlitz());
}

class TodoBlitz extends StatelessWidget {
  const TodoBlitz({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskStore('tasks.json'),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
          useMaterial3: true,
        ),
        home: const TodoListPage(),
        routes: {
          // '/': (context) => const TodoListPage(),
          '/config': (context) => const SettingsPage(),
        },
      ),
    );
  }
}
