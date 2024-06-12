import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/calendar_model.dart';

class CalendarDao {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> insertCalendar(Calendar calendar) async {
    await _db.collection('calendars').add(calendar.toMap());
  }

  Future<List<Calendar>> getCalendars() async {
    QuerySnapshot snapshot = await _db.collection('calendars').get();
    return snapshot.docs
        .map((doc) => Calendar.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateCalendar(String id, Calendar calendar) async {
    await _db.collection('calendars').doc(id).update(calendar.toMap());
  }

  Future<void> deleteCalendar(String id) async {
    await _db.collection('calendars').doc(id).delete();
  }
}
