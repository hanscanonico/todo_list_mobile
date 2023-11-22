import 'package:flutter/material.dart';
import 'package:todo_list_mobile/services/TaskService.dart';

class TaskWidget extends StatefulWidget {
  final String taskName;
  final int taskId;
  final int listId;
  final bool isDone;

  const TaskWidget(
      {Key? key,
      required this.taskName,
      required this.taskId,
      required this.listId,
      required this.isDone})
      : super(key: key);

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  late bool _isDone;

  @override
  void initState() {
    super.initState();
    _isDone = widget.isDone;
  }

  void _toggleDone() {
    TaskService().toggleTask(widget.listId, widget.taskId);
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
