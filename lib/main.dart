import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import './pages/home/home_page.dart';
import './pages/auth/login_page.dart';
import './pages/auth/register_page.dart';
import './pages/dashboard/dashboard_page.dart';
import './pages/tasks/task_list_page.dart';
import './pages/tasks/task_detail_page.dart';
import './pages/tasks/task_edit_page.dart';
import './pages/profile/profile_page.dart';
import './data/init_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final initData = InitData();
  await initData.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion de Tâches',
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/dashboard': (context) => DashboardPage(),
        '/tasks': (context) => TaskListPage(),
        '/task_detail': (context) => TaskDetailPage(),
        '/task_edit': (context) => TaskEditPage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}
