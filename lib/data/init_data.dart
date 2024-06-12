import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InitData {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> initialize() async {
    try {
      await _insertUsers();
      await _insertCalendars();
      await _insertTasks();
      await _insertNotes();
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  Future<void> _insertUsers() async {
    final users = [
      {
        'email': 'testuser1@example.com',
        'password': 'password123',
        'username': 'testuser1',
        'phoneNumber': '1234567890'
      },
      {
        'email': 'testuser2@example.com',
        'password': 'password123',
        'username': 'testuser2',
        'phoneNumber': '1234567891'
      },
      {
        'email': 'testuser3@example.com',
        'password': 'password123',
        'username': 'testuser3',
        'phoneNumber': '1234567892'
      },
    ];

    for (var user in users) {
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: user['email']!,
          password: user['password']!,
        );

        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'username': user['username'],
          'email': userCredential.user!.email,
          'phoneNumber': user['phoneNumber'],
        });
      } catch (e) {
        print('Error creating user: $e');
      }
    }
  }

  Future<void> _insertCalendars() async {
    final users = await _firestore.collection('users').get();

    for (var user in users.docs) {
      await _firestore.collection('calendars').add({
        'userId': user.id,
        'calendarName': 'Personnel',
      });

      await _firestore.collection('calendars').add({
        'userId': user.id,
        'calendarName': 'Professionnel',
      });

      await _firestore.collection('calendars').add({
        'userId': user.id,
        'calendarName': 'Anniversaire',
      });
    }
  }

  Future<void> _insertTasks() async {
    final users = await _firestore.collection('users').get();
    final taskTitles = ['Task 1', 'Task 2', 'Task 3', 'Task 4', 'Task 5'];

    for (var user in users.docs) {
      final calendars = await _firestore
          .collection('calendars')
          .where('userId', isEqualTo: user.id)
          .get();

      for (var calendar in calendars.docs) {
        for (var title in taskTitles) {
          await _firestore.collection('tasks').add({
            'calendarId': calendar.id,
            'title': title,
            'description': '$title description',
            'dueDate': Timestamp.now(),
            'isCompleted': false,
          });
        }
      }
    }
  }

  Future<void> _insertNotes() async {
    final users = await _firestore.collection('users').get();
    final noteTitles = ['Note 1', 'Note 2', 'Note 3', 'Note 4', 'Note 5'];

    for (var user in users.docs) {
      for (var title in noteTitles) {
        await _firestore.collection('notes').add({
          'userId': user.id,
          'title': title,
          'content': '$title content',
          'createdDate': Timestamp.now(),
        });
      }
    }
  }
}
