import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'forgot_password_screen.dart';
import 'login_screen.dart';
import 'menu_screen.dart';
import 'profile_screen.dart';
import 'register_screen.dart';
import 'cover_screen.dart'; // استيراد CoverScreen
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // تأكد من استدعاء هذه الدالة
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/cover', // شاشة البداية
      routes: {
        '/cover': (context) => CoverScreen(), // ربط CoverScreen
        '/login': (context) => LoginScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/profile': (context) => ProfileScreen(),
        '/register': (context) => RegisterScreen(),
        '/forgot_password': (context) => ForgotPasswordScreen(),
      },
    );
  }
}
