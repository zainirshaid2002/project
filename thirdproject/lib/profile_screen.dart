import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  String name = "Loading...";
  String username = "Loading...";
  String email = "Loading...";
  String code = "Loading...";
  String phone = "Loading...";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, String>;
      final String systemCode = args['SystemCode'] ?? "";
      final String userId = args['userId'] ?? "";

      // جلب بيانات المستخدم من قاعدة البيانات بناءً على SystemCode و userId
      databaseRef.child("system/$systemCode/User/$userId").get().then((snapshot) {
        if (snapshot.exists) {
          final data = snapshot.value as Map<dynamic, dynamic>;
          setState(() {
            name = data['Name']?.toString() ?? "No Name";
            username = data['Username']?.toString() ?? "No Username";
            email = data['Email']?.toString() ?? "No Email";
            code = systemCode;
            phone = data['PhoneNumber']?.toString() ?? "No Phone";
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("User data not found.")),
          );
        }
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetching data: $error")),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Info"),
      ),
      body: Stack(
        children: [
          // الخلفية
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/profile.png'), // اسم الصورة: profile.png
                fit: BoxFit.cover, // تجعل الصورة تغطي الصفحة بالكامل
              ),
            ),
          ),
          // محتوى الملف الشخصي
          Container(
            color: Colors.black.withOpacity(0.5), // طبقة شفافة فوق الخلفية لتوضيح النصوص
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // يضمن توسيط المحتوى عموديًا
                  children: [
                    _buildProfileItem("Name", name),
                    _buildDivider(),
                    _buildProfileItem("Username", username),
                    _buildDivider(),
                    _buildProfileItem("Email", email),
                    _buildDivider(),
                    _buildProfileItem("Code", code),
                    _buildDivider(),
                    _buildProfileItem("Phone", phone),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          // العمود الأول
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // العمود الثاني
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center, // لتوسيط النصوص
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(
        color: Colors.white,
        thickness: 1,
      ),
    );
  }
}
