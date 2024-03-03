import 'package:flutter/material.dart';
import 'package:todo_list_mobile/screens/LoginPage.dart';
import 'package:todo_list_mobile/services/UserService.dart';
import 'package:todo_list_mobile/widgets/AddListWidget.dart';
import 'package:todo_list_mobile/widgets/EditListWidget.dart';
import 'package:todo_list_mobile/widgets/ListWidget.dart';
import 'package:todo_list_mobile/services/ListService.dart';

class ListsPage extends StatefulWidget {
  const ListsPage({super.key});

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListsPage> {
  late Future<List<dynamic>> listsFuture;
  final TextEditingController _listNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    listsFuture = ListService().getLists().catchError((error) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginPage()));
      });
    });
  }

  void _showAddListDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddListWidget(
          taskNameController: _listNameController,
          onAdd: (String listName) async {
            try {
              await ListService().createList({'name': listName});
              setState(() {
                listsFuture = ListService().getLists();
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

  void _showEditListDialog(Map list) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditListWidget(
          list: list,
          onEdit: (String newListName) async {
            try {
              await ListService().updateList(list['id'], {'name': newListName});
              setState(() {
                listsFuture = ListService().getLists();
              });
              Navigator.of(context).pop();
            } catch (e) {
              print('Error updating list: $e');
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
        title: const Text('Lists'),
        actions: <Widget>[
          // Add this line
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              UserService().signOut();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()));
              print('Sign out');
            },
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: listsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No lists found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var list = snapshot.data![index];
                return Dismissible(
                    key: Key(list['id'].toString()),
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
                    direction: DismissDirection.horizontal,
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.endToStart) {
                        await ListService().deleteList(list['id']);
                        setState(() {
                          listsFuture = ListService().getLists();
                        });
                        return true;
                      } else {
                        _showEditListDialog(list);
                      }
                    },
                    child:
                        ListWidget(listName: list['name'], listId: list['id']));
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddListDialog,
        child: Icon(Icons.add),
        tooltip: 'Create List',
      ),
    );
  }
}
