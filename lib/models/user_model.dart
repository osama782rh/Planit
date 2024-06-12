class User {
  final String? userId;
  final String username;
  final String email;
  final String? age;
  final String phoneNumber;

  User({
    this.userId,
    required this.username,
    required this.email,
    this.age,
    required this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
      'age': age,
      'phoneNumber': phoneNumber,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['userId'],
      username: map['username'],
      email: map['email'],
      age: map['age'],
      phoneNumber: map['phoneNumber'],
    );
  }
}
