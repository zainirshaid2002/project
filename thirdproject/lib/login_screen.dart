import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _systemCodeController = TextEditingController();
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

  bool _obscurePassword = true; // متغير للتحكم في عرض أو إخفاء كلمة المرور

  void _login(BuildContext context) async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    String systemCode = _systemCodeController.text;

    databaseRef.child('system').child(systemCode).get().then((snapshot) {
      if (snapshot.exists) {
        Map<dynamic, dynamic> systemData = snapshot.value as Map<dynamic, dynamic>;

        bool userFound = false;
        String userId = "";

        if (systemData.containsKey('User')) {
          Map<dynamic, dynamic> users = systemData['User'] as Map<dynamic, dynamic>;

          users.forEach((userIdTemp, userData) {
            if (userData['Username'] == username &&
                userData['Password'].toString() == password) {
              userFound = true;
              userId = userIdTemp;
            }
          });
        }

        if (userFound) {
          Navigator.pushNamed(
            context,
            '/dashboard',
            arguments: {'SystemCode': systemCode, 'userId': userId},
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Invalid username, password, or system code")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("System code not found in the database")),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/solgrid_logo2.png',
                height: 100,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 40),
              _buildTextField(
                controller: _systemCodeController,
                label: "System Code",
                icon: Icons.code,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: _usernameController,
                label: "Username",
                icon: Icons.person,
              ),
              SizedBox(height: 20),
              _buildPasswordField(), // استدعاء حقل الباسوورد المعدل
              SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: ElevatedButton(
                  onPressed: () => _login(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Sign In",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/forgot_password');
                },
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.white),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        decoration: InputDecoration(
          labelText: "Password",
          prefixIcon: Icon(Icons.lock, color: Colors.white),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility : Icons.visibility_off,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
      ),
    );
  }
}
