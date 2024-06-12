class Calendar {
  final int? calendarId;
  final String userId;
  final String calendarName;

  Calendar({
    this.calendarId,
    required this.userId,
    required this.calendarName,
  });

  Map<String, dynamic> toMap() {
    return {
      'calendarId': calendarId,
      'userId': userId,
      'calendarName': calendarName,
    };
  }

  factory Calendar.fromMap(Map<String, dynamic> map) {
    return Calendar(
      calendarId: map['calendarId'],
      userId: map['userId'],
      calendarName: map['calendarName'],
    );
  }
}
