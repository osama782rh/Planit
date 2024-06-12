import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserDao {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> insertUser(User user) async {
    await _db.collection('users').add(user.toMap());
  }

  Future<List<User>> getUsers() async {
    QuerySnapshot snapshot = await _db.collection('users').get();
    return snapshot.docs
        .map((doc) => User.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateUser(String id, User user) async {
    await _db.collection('users').doc(id).update(user.toMap());
  }

  Future<void> deleteUser(String id) async {
    await _db.collection('users').doc(id).delete();
  }
}
