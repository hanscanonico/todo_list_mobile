import 'package:flutter/material.dart';
import 'package:todo_list_mobile/screens/LoginPage.dart';
import 'package:todo_list_mobile/services/UserService.dart';
import 'package:todo_list_mobile/widgets/AddTaskWidget.dart';
import 'package:todo_list_mobile/widgets/EditTaskWidget.dart';
import 'package:todo_list_mobile/widgets/TaskWidget.dart';
import 'package:todo_list_mobile/services/TaskService.dart';

class TasksPage extends StatefulWidget {
  final int listId;
  final String listName;

  const TasksPage({Key? key, required this.listId, required this.listName})
      : super(key: key);

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  late Future<List<dynamic>> tasksFuture;
  final TextEditingController _taskNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    tasksFuture = _loadTasks();
  }

  Future<List<dynamic>> _loadTasks() {
    return TaskService().getTasks(widget.listId);
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddTaskWidget(
          taskNameController: _taskNameController,
          onAdd: (String taskName) async {
            try {
              await TaskService()
                  .createTask(widget.listId, {'name': taskName, 'done': false});
              setState(() {
                tasksFuture = _loadTasks();
              });
              Navigator.of(context).pop();
            } catch (e) {
              print('Error creating task: $e');
            }
          },
        );
      },
    );
  }

  void _showEditTaskDialog(Map task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditTaskWidget(
          task: task,
          onEdit: (String newTaskName) async {
            try {
              await TaskService()
                  .updateTask(widget.listId, task['id'], {'name': newTaskName});
              setState(() {
                tasksFuture = _loadTasks();
              });
              Navigator.of(context).pop();
            } catch (e) {
              print('Error updating task: $e');
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Tasks for ${widget.listName}'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              UserService().signOut();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No tasks found'));
          } else {
            return ReorderableListView(
              onReorder: (int oldIndex, int newIndex) async {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                final currentItem = snapshot.data![oldIndex];

                final oldItemId = currentItem['id'];
                final newItemId = snapshot.data![newIndex]['id'];

                print(
                    'Moving item with ID $oldItemId from index $oldIndex to index $newIndex where item with ID $newItemId currently resides.');

                setState(() {
                  snapshot.data!.removeAt(oldIndex);
                  snapshot.data!.insert(newIndex, currentItem);
                });

                try {
                  await TaskService()
                      .switchOrder(widget.listId, oldItemId, newItemId);
                } catch (error) {
                  print('Error updating list order: $error');
                }
              },
              children: snapshot.data!
                  .map((task) => Dismissible(
                        key: Key('task-${task['id']}'),
                        background: Container(
                          color: Colors.blue,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 20.0),
                          child: Icon(Icons.edit, color: Colors.white),
                        ),
                        secondaryBackground: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20.0),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) async {
                          if (direction == DismissDirection.endToStart) {
                            await TaskService()
                                .deleteTask(widget.listId, task['id']);
                            setState(() {
                              tasksFuture = _loadTasks();
                            });
                          } else {
                            _showEditTaskDialog(task);
                          }
                        },
                        child: TaskWidget(
                            key: ValueKey('task-widget-${task['id']}'),
                            taskName: task['name'],
                            isDone: task['done'],
                            taskId: task['id'],
                            listId: widget.listId),
                      ))
                  .toList(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: Icon(Icons.add),
        tooltip: 'Create Task',
      ),
    );
  }
}
