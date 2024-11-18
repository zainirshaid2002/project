import 'package:flutter/material.dart';
import 'dart:async';

class CoverScreen extends StatefulWidget {
  @override
  _CoverScreenState createState() => _CoverScreenState();
}

class _CoverScreenState extends State<CoverScreen> {
  @override
  void initState() {
    super.initState();
    // الانتقال إلى صفحة تسجيل الدخول بعد 3 ثوانٍ
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // خلفية الصفحة بيضاء
      body: Center(
        child: Image.asset(
          'assets/solgrid_logo2.png', // الصورة المطلوبة
          height: 150, // تحديد ارتفاع الصورة
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
