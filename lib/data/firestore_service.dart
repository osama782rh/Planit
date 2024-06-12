import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Méthodes pour gérer les utilisateurs
  Future<void> addUser(Map<String, dynamic> data) async {
    await _db.collection('users').add(data);
  }

  Future<QuerySnapshot> getUsers() async {
    return await _db.collection('users').get();
  }

  // Méthodes pour gérer les tâches
  Future<void> addTask(Map<String, dynamic> data) async {
    await _db.collection('tasks').add(data);
  }

  Future<QuerySnapshot> getTasks() async {
    return await _db.collection('tasks').get();
  }

  Future<void> updateTask(String taskId, Map<String, dynamic> data) async {
    await _db.collection('tasks').doc(taskId).update(data);
  }

  // Méthodes pour gérer les calendriers
  Future<void> addCalendar(Map<String, dynamic> data) async {
    await _db.collection('calendars').add(data);
  }

  Future<QuerySnapshot> getCalendars() async {
    return await _db.collection('calendars').get();
  }

  // Méthodes pour gérer les notes
  Future<void> addNote(Map<String, dynamic> data) async {
    await _db.collection('notes').add(data);
  }

  Future<QuerySnapshot> getNotes() async {
    return await _db.collection('notes').get();
  }
}
