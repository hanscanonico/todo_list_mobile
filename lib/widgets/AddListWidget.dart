// add_task_dialog.dart
import 'package:flutter/material.dart';

class AddListWidget extends StatelessWidget {
  final TextEditingController taskNameController;
  final Function(String) onAdd;

  AddListWidget(
      {Key? key, required this.taskNameController, required this.onAdd})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add a New List'),
      content: TextFormField(
        controller: taskNameController,
        decoration: InputDecoration(hintText: 'Enter list name'),
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
