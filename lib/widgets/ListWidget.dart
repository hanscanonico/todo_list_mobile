import 'package:flutter/material.dart';
import 'package:todo_list_mobile/screens/TasksPage.dart';

class ListWidget extends StatefulWidget {
  final String listName;
  final int listId;

  const ListWidget({Key? key, required this.listName, required this.listId})
      : super(key: key);

  @override
  _ListWidgetState createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListTile(
        title: Text(
          widget.listName,
          style: TextStyle(
            fontSize: 20,
          ),
          textAlign: TextAlign.left,
        ),
        trailing: Icon(Icons.arrow_forward_sharp),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => TasksPage(
                      listId: widget.listId,
                      listName: widget.listName,
                    )),
          );
        },
      ),
    );
  }
}
