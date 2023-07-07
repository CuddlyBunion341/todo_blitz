import 'package:flutter/material.dart';

/// A dialog widget.
class DialogWidget extends StatelessWidget {
  final String id;
  final String title;
  final String body;
  final Function callback;

  static List<DialogWidget> dialogs = [];

  DialogWidget(this.id, this.title, this.body, this.callback, {super.key}) {
    dialogs.add(this);
  }

  void _remove() {
    dialogs.remove(this);
  }

  static bool dialogExists(String id) {
    return dialogs.any((element) => element.id == id);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'Cancel');
            _remove();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'Ok');
            _remove();
            callback();
          },
          child: const Text('Ok'),
        ),
      ],
    );
    // body: Column(
    //     children: [
    //       Text(title),
    //       Text(body),
    //       TextButton(
    //         onPressed: () {
    //           Navigator.pop(context);
    //           callback();
    //           _remove();
    //         },
    //         child: const Text('OK'),
    //       ),
    //       TextButton(
    //         onPressed: () {
    //           Navigator.pop(context);
    //           _remove();
    //         },
    //         child: const Text('Close'),
    //       ),
    //     ],
    //   ),
    // ),
  }
}
