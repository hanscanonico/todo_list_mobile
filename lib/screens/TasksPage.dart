import 'package:flutter/material.dart';
import 'package:todo_list_mobile/widgets/Task.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Tasks'),
      ),
      body: ListView(
        children: [
          const Task(taskName: 'Complete Homework'),
          const Task(taskName: 'Go for a Walk'),
          const Task(taskName: 'Read a Book'),
        ],
      ),
    );
  }
}
