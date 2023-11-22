// add_task_dialog.dart
import 'package:flutter/material.dart';

class AddTaskWidget extends StatelessWidget {
  final TextEditingController taskNameController;
  final Function(String) onAdd;

  AddTaskWidget(
      {Key? key, required this.taskNameController, required this.onAdd})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add a New Task'),
      content: TextFormField(
        controller: taskNameController,
        decoration: InputDecoration(hintText: 'Enter task name'),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text('Add'),
          onPressed: () => onAdd(taskNameController.text),
        ),
      ],
    );
  }
}
