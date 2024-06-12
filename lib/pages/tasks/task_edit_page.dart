import 'package:flutter/material.dart';
import '../../data/firestore_service.dart';
import '../../models/task_model.dart';

class TaskEditPage extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final Task? task = ModalRoute.of(context)!.settings.arguments as Task?;

    if (task != null) {
      titleController.text = task.title;
      descriptionController.text = task.description ?? '';
      dueDateController.text = task.dueDate ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(task == null ? 'Créer une tâche' : 'Modifier la tâche'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Titre'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: dueDateController,
              decoration: InputDecoration(labelText: 'Date d\'échéance'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                if (task == null) {
                  Task newTask = Task(
                    calendarId: 1,
                    title: titleController.text,
                    description: descriptionController.text,
                    dueDate: dueDateController.text,
                    isCompleted: false,
                  );
                  await firestoreService.addTask(newTask.toMap());
                } else {
                  Task updatedTask = Task(
                    taskId: task.taskId,
                    calendarId: task.calendarId,
                    title: titleController.text,
                    description: descriptionController.text,
                    dueDate: dueDateController.text,
                    isCompleted: task.isCompleted,
                  );
                  await firestoreService.updateTask(
                      task.taskId!, updatedTask.toMap());
                }
                Navigator.pop(context);
              },
              child: Text(task == null ? 'Créer' : 'Mettre à jour'),
            ),
          ],
        ),
      ),
    );
  }
}
