import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTaskPage extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: dueDateController,
              decoration: InputDecoration(labelText: 'Due Date (YYYY-MM-DD)'),
            ),
            ElevatedButton(
              onPressed: () {
                _addTask();
              },
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addTask() async {
    String title = titleController.text;
    String description = descriptionController.text;
    DateTime dueDate = DateTime.parse(dueDateController.text);

    CollectionReference tasks = FirebaseFirestore.instance.collection('tache');
    tasks.add({
      'title': title,
      'description': description,
      'dueDate': Timestamp.fromDate(dueDate),
      'completed': false,
      'userID': '', // Assign a user ID if needed
      'calendarID': '', // Assign a calendar ID if needed
      'assigneTo': [], // Assign to users if needed
    }).then((value) {
      print("Task Added");
    }).catchError((error) {
      print("Failed to add task: $error");
    });
  }
}
