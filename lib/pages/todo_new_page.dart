import 'package:flutter/widgets.dart';

class TodoNewPage extends StatefulWidget {
  const TodoNewPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TodoNewPageState();
  }
}

class TodoNewPageState extends State<TodoNewPage> {
  String title;
  DateTime date;

  TodoNewPageState()
      : title = '',
        date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return const Text('Todo New Page');
  }
}
