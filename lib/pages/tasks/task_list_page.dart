import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskListPage extends StatefulWidget {
  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _deleteTask(String taskId) async {
    await _firestore.collection('tasks').doc(taskId).delete();
    setState(() {}); // Refresh the task list
  }

  void _showTaskForm({String? taskId, Map<String, dynamic>? taskData}) {
    final TextEditingController _titleController =
        TextEditingController(text: taskData?['title'] ?? '');
    final TextEditingController _descriptionController =
        TextEditingController(text: taskData?['description'] ?? '');
    final TextEditingController _dueDateController = TextEditingController(
        text: taskData != null
            ? (taskData['dueDate'] as Timestamp).toDate().toString()
            : '');
    List<String> selectedContacts =
        List<String>.from(taskData?['contacts'] ?? []);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              Text(taskId != null ? 'Modifier la tâche' : 'Ajouter une tâche'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Titre'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: _dueDateController,
                  decoration: InputDecoration(labelText: 'Date d\'échéance'),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      _dueDateController.text = pickedDate.toString();
                    }
                  },
                ),
                FutureBuilder<QuerySnapshot>(
                  future: _firestore
                      .collection('contacts')
                      .where('userId', isEqualTo: _auth.currentUser!.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final contacts = snapshot.data!.docs;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        final contact = contacts[index];
                        return CheckboxListTile(
                          title: Text(contact['name']),
                          value: selectedContacts.contains(contact.id),
                          onChanged: (isSelected) {
                            setState(() {
                              if (isSelected == true) {
                                selectedContacts.add(contact.id);
                              } else {
                                selectedContacts.remove(contact.id);
                              }
                            });
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                final user = _auth.currentUser;
                if (user != null) {
                  if (taskId != null) {
                    await _firestore.collection('tasks').doc(taskId).update({
                      'title': _titleController.text,
                      'description': _descriptionController.text,
                      'dueDate': Timestamp.fromDate(
                          DateTime.parse(_dueDateController.text)),
                      'contacts': selectedContacts,
                    });
                  } else {
                    await _firestore.collection('tasks').add({
                      'userId': user.uid,
                      'title': _titleController.text,
                      'description': _descriptionController.text,
                      'dueDate': Timestamp.fromDate(
                          DateTime.parse(_dueDateController.text)),
                      'contacts': selectedContacts,
                      'isCompleted': false,
                    });
                  }
                  Navigator.of(context).pop();
                }
              },
              child: Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Tâches'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showTaskForm(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('tasks')
                  .where('userId', isEqualTo: _auth.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final tasks = snapshot.data!.docs;
                print(
                    "Found ${tasks.length} tasks for user ${_auth.currentUser!.uid}");

                if (tasks.isEmpty) {
                  return Center(child: Text('Aucune tâche trouvée.'));
                }

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return ListTile(
                      title: Text(task['title']),
                      subtitle: Text(task['description']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _showTaskForm(
                                taskId: task.id,
                                taskData: task.data() as Map<String, dynamic>),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteTask(task.id),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/dashboard');
            },
            child: Text('Retour à l\'accueil'),
          ),
        ],
      ),
    );
  }
}
