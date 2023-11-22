import 'package:flutter/material.dart';

class EditListWidget extends StatelessWidget {
  final Map list;
  final Function(String) onEdit;
  final TextEditingController _listNameController = TextEditingController();

  EditListWidget({Key? key, required this.list, required this.onEdit})
      : super(key: key) {
    _listNameController.text = list['name'];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit List'),
      content: TextFormField(
        controller: _listNameController,
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text('Save'),
          onPressed: () => onEdit(_listNameController.text),
        ),
      ],
    );
  }
}
