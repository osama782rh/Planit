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
      await _insertContacts();
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  Future<void> _insertUsers() async {
    final users = [
      {
        'email': 'newuser1@example.com',
        'password': 'newpassword123',
        'username': 'newuser1',
        'firstName': 'John',
        'lastName': 'Doe',
        'age': 30,
        'address': '123 Main St',
        'city': 'Anytown',
        'country': 'USA',
        'phoneNumber': '1234567893'
      },
      {
        'email': 'newuser2@example.com',
        'password': 'newpassword123',
        'username': 'newuser2',
        'firstName': 'Jane',
        'lastName': 'Smith',
        'age': 25,
        'address': '456 Elm St',
        'city': 'Othertown',
        'country': 'USA',
        'phoneNumber': '1234567894'
      },
      {
        'email': 'newuser3@example.com',
        'password': 'newpassword123',
        'username': 'newuser3',
        'firstName': 'Alice',
        'lastName': 'Johnson',
        'age': 28,
        'address': '789 Oak St',
        'city': 'Sometown',
        'country': 'USA',
        'phoneNumber': '1234567895'
      },
      {
        'email': 'newuser4@example.com',
        'password': 'newpassword123',
        'username': 'newuser4',
        'firstName': 'Mike',
        'lastName': 'Brown',
        'age': 40,
        'address': '321 Maple St',
        'city': 'Newcity',
        'country': 'USA',
        'phoneNumber': '1234567896'
      },
      {
        'email': 'newuser5@example.com',
        'password': 'newpassword123',
        'username': 'newuser5',
        'firstName': 'Sara',
        'lastName': 'Davis',
        'age': 35,
        'address': '654 Pine St',
        'city': 'Oldtown',
        'country': 'USA',
        'phoneNumber': '1234567897'
      }
    ];

    for (var user in users) {
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: user['email'] as String,
          password: user['password'] as String,
        );

        await userCredential.user!.reload();
        User? updatedUser = _auth.currentUser;
        if (updatedUser != null) {
          await _firestore.collection('users').doc(updatedUser.uid).set({
            'username': user['username'] as String,
            'firstName': user['firstName'] as String,
            'lastName': user['lastName'] as String,
            'age': user['age'] as int,
            'address': user['address'] as String,
            'city': user['city'] as String,
            'country': user['country'] as String,
            'email': updatedUser.email,
            'phoneNumber': user['phoneNumber'] as String,
          });

          print('User ${user['email']} created successfully');
        } else {
          print('Failed to reload the user.');
        }
      } catch (e) {
        print('Error creating user ${user['email']}: $e');
      }
    }
  }

  Future<void> _insertCalendars() async {
    final users = await _firestore.collection('users').get();
    final calendarNames = [
      'Personnel',
      'Professionnel',
      'Vacances',
      'Santé',
      'Projets'
    ];

    for (var user in users.docs) {
      for (var calendarName in calendarNames) {
        try {
          await _firestore.collection('calendars').add({
            'userId': user.id,
            'calendarName': calendarName,
          });

          print(
              'Calendar $calendarName for user ${user.id} created successfully');
        } catch (e) {
          print(
              'Error creating calendar $calendarName for user ${user.id}: $e');
        }
      }
    }
  }

  Future<void> _insertTasks() async {
    final users = await _firestore.collection('users').get();
    final taskTitles = [
      'Acheter du lait',
      'Préparer la réunion',
      'Appeler le docteur',
      'Réviser le rapport',
      'Organiser la fête',
      'Faire du sport',
      'Réparation de la voiture',
      'Rencontrer le client',
      'Réserver des billets',
      'Planifier le projet'
    ];

    for (var user in users.docs) {
      final calendars = await _firestore
          .collection('calendars')
          .where('userId', isEqualTo: user.id)
          .get();

      for (var calendar in calendars.docs) {
        for (var title in taskTitles) {
          try {
            await _firestore.collection('tasks').add({
              'calendarId': calendar.id,
              'title': title,
              'description': '$title description',
              'dueDate': Timestamp.fromDate(DateTime.now()
                  .add(Duration(days: taskTitles.indexOf(title)))),
              'isCompleted': false,
            });

            print(
                'Task $title for calendar ${calendar.id} created successfully');
          } catch (e) {
            print('Error creating task $title for calendar ${calendar.id}: $e');
          }
        }
      }
    }
  }

  Future<void> _insertContacts() async {
    final users = await _firestore.collection('users').get();
    final contactNames = [
      {
        'name': 'Bob Martin',
        'email': 'bob.martin@example.com',
        'phoneNumber': '1234567890'
      },
      {
        'name': 'Charlie Bernard',
        'email': 'charlie.bernard@example.com',
        'phoneNumber': '1234567891'
      },
      {
        'name': 'David Thomas',
        'email': 'david.thomas@example.com',
        'phoneNumber': '1234567892'
      },
      {
        'name': 'Eva Green',
        'email': 'eva.green@example.com',
        'phoneNumber': '1234567893'
      },
      {
        'name': 'Fiona Scott',
        'email': 'fiona.scott@example.com',
        'phoneNumber': '1234567894'
      },
      {
        'name': 'George Lee',
        'email': 'george.lee@example.com',
        'phoneNumber': '1234567895'
      },
    ];

    for (var user in users.docs) {
      for (var contact in contactNames) {
        try {
          await _firestore.collection('contacts').add({
            'userId': user.id,
            'name': contact['name'],
            'email': contact['email'],
            'phoneNumber': contact['phoneNumber'],
          });

          print(
              'Contact ${contact['name']} for user ${user.id} created successfully');
        } catch (e) {
          print(
              'Error creating contact ${contact['name']} for user ${user.id}: $e');
        }
      }
    }
  }
}
