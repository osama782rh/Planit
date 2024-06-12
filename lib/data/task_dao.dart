import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class TaskDao {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> insertTask(Task task) async {
    await _db.collection('tasks').add(task.toMap());
  }

  Future<List<Task>> getTasks() async {
    QuerySnapshot snapshot = await _db.collection('tasks').get();
    return snapshot.docs
        .map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateTask(String id, Task task) async {
    await _db.collection('tasks').doc(id).update(task.toMap());
  }

  Future<void> deleteTask(String id) async {
    await _db.collection('tasks').doc(id).delete();
  }
}
