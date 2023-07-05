import 'package:flutter/material.dart';
import 'package:todo_blitz/pages/todo_list_page.dart';

void main() {
  runApp(const TodoBlitz());
}

class TodoBlitz extends StatelessWidget {
  const TodoBlitz({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TodoListPage(),
    );
  }
}
