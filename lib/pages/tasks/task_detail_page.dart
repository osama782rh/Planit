import 'package:flutter/material.dart';
import '../../models/task_model.dart';

class TaskDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Task task = ModalRoute.of(context)!.settings.arguments as Task;

    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Description: ${task.description ?? 'Aucune description'}'),
            SizedBox(height: 8.0),
            Text('Date d\'échéance: ${task.dueDate ?? 'Pas de date'}'),
            SizedBox(height: 8.0),
            Text('Complété: ${task.isCompleted ? 'Oui' : 'Non'}'),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/task_edit', arguments: task);
              },
              child: Text('Modifier la tâche'),
            ),
          ],
        ),
      ),
    );
  }
}
