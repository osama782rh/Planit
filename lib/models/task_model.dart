class Task {
  final String? taskId;
  final int calendarId;
  final String title;
  final String? description;
  final String? dueDate;
  final bool isCompleted;

  Task({
    this.taskId,
    required this.calendarId,
    required this.title,
    this.description,
    this.dueDate,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'calendarId': calendarId,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'isCompleted': isCompleted,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      taskId: map['taskId'],
      calendarId: map['calendarId'],
      title: map['title'],
      description: map['description'],
      dueDate: map['dueDate'],
      isCompleted: map['isCompleted'],
    );
  }
}
