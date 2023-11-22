import 'package:flutter/material.dart';

class EditTaskWidget extends StatelessWidget {
  final Map task;
  final Function(String) onEdit;
  final TextEditingController _taskNameController = TextEditingController();

  EditTaskWidget({Key? key, required this.task, required this.onEdit})
      : super(key: key) {
    _taskNameController.text = task['name'];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Task'),
      content: TextFormField(
        controller: _taskNameController,
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text('Save'),
          onPressed: () => onEdit(_taskNameController.text),
        ),
      ],
    );
  }
}
