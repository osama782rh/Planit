import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarsPage extends StatefulWidget {
  @override
  _CalendarsPageState createState() => _CalendarsPageState();
}

class _CalendarsPageState extends State<CalendarsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  Map<String, List<dynamic>> _tasks = {};
  String? _selectedCalendarId;
  List<QueryDocumentSnapshot> _calendars = [];

  @override
  void initState() {
    super.initState();
    _loadCalendars();
  }

  Future<void> _loadCalendars() async {
    final user = _auth.currentUser;
    if (user != null) {
      final calendarSnapshots = await _firestore
          .collection('calendars')
          .where('userId', isEqualTo: user.uid)
          .get();

      setState(() {
        _calendars = calendarSnapshots.docs;
        _tasks.clear();
        for (var calendarDoc in _calendars) {
          _firestore
              .collection('tasks')
              .where('calendarId', isEqualTo: calendarDoc.id)
              .snapshots()
              .listen((taskSnapshots) {
            setState(() {
              _tasks[calendarDoc.id] =
                  taskSnapshots.docs.map((doc) => doc.data()).toList();
            });
          });
        }
      });
    }
  }

  List<dynamic> _getTasksForDay(DateTime day) {
    if (_selectedCalendarId == null ||
        !_tasks.containsKey(_selectedCalendarId)) {
      return [];
    }
    return _tasks[_selectedCalendarId]!.where((task) {
      final taskDate = (task['dueDate'] as Timestamp).toDate();
      return isSameDay(taskDate, day);
    }).toList();
  }

  Future<void> _addCalendar(String calendarName) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('calendars').add({
        'userId': user.uid,
        'calendarName': calendarName,
      });
      _loadCalendars();
    }
  }

  void _showAddCalendarDialog() {
    final TextEditingController _calendarNameController =
        TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ajouter un calendrier'),
          content: TextField(
            controller: _calendarNameController,
            decoration: InputDecoration(labelText: 'Nom du calendrier'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                final calendarName = _calendarNameController.text.trim();
                if (calendarName.isNotEmpty) {
                  _addCalendar(calendarName);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Ajouter'),
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
        title: Text('Mes Calendriers'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddCalendarDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_calendars.isNotEmpty)
            DropdownButton<String>(
              hint: Text('Sélectionner un calendrier'),
              value: _selectedCalendarId,
              onChanged: (value) {
                setState(() {
                  _selectedCalendarId = value;
                });
              },
              items: _calendars
                  .map((calendar) => DropdownMenuItem<String>(
                        value: calendar.id,
                        child: Text(calendar['calendarName']),
                      ))
                  .toList(),
            ),
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: _getTasksForDay,
          ),
          ..._getTasksForDay(_selectedDay).map((task) => ListTile(
                title: Text(task['title']),
                subtitle: Text(task['description']),
              )),
        ],
      ),
    );
  }
}
