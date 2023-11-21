import 'package:flutter/material.dart';

class Task extends StatefulWidget {
  final String taskName;

  const Task({Key? key, required this.taskName}) : super(key: key);

  @override
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Task> {
  bool _isDone = false;

  void _toggleDone() {
    setState(() {
      _isDone = !_isDone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.taskName,
        style: TextStyle(
          decoration: _isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: IconButton(
        icon: Icon(
          _isDone ? Icons.check_box : Icons.check_box_outline_blank,
        ),
        onPressed: _toggleDone,
      ),
    );
  }
}
