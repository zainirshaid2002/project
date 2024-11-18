import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // تعيين الخلفية إلى اللون الأبيض
      appBar: AppBar(
        title: Text("Forgot Password?"),
        backgroundColor: Colors.orange, // لون AppBar
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // حقل إدخال البريد الإلكتروني
              Container(
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Enter your email address",
                    labelStyle: TextStyle(color: Colors.black),
                    prefixIcon: Icon(Icons.email, color: Colors.white),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "* We will send you a message to set or reset your new password",
                style: TextStyle(color: Colors.blue, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),

              // زر "Send Code by Phone Number"
              SizedBox(
                width: MediaQuery.of(context).size.width, // يأخذ عرض الصفحة بالكامل
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // تنفيذ الإجراء لإرسال الكود عبر الهاتف
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        "Send code by phone number",
                        style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),

              // زر "Send Code by Email"
              SizedBox(
                width: MediaQuery.of(context).size.width, // يأخذ عرض الصفحة بالكامل
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // تنفيذ الإجراء لإرسال الكود عبر البريد الإلكتروني
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.email, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        "Send code by email",
                        style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
