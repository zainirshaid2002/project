import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _systemCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final DatabaseReference ref = FirebaseDatabase.instance.ref();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void registerUser() async {
    String name = _nameController.text;
    String username = _usernameController.text;
    String phoneNumber = _phoneNumberController.text;
    String email = _emailController.text;
    String systemCode = _systemCodeController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    ref.child('system').child(systemCode).get().then((snapshot) {
      if (snapshot.exists) {
        ref.child('system/$systemCode/User').get().then((userSnapshot) {
          int userCount = userSnapshot.children.length + 1;
          String newUserKey = "User$userCount";

          ref.child('system/$systemCode/User/$newUserKey').set({
            "Name": name,
            "Username": username,
            "PhoneNumber": phoneNumber,
            "Email": email,
            "Password": password,
          }).then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("User registered successfully")),
            );
            Navigator.pushReplacementNamed(context, '/dashboard', arguments: {
              'SystemCode': systemCode,
              'userId': newUserKey,
            });
          });
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("System code not found in the database.")),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create an account")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Create an account",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            _buildTextField("Name", Icons.person, _nameController),
            _buildTextField("Username", Icons.person_outline, _usernameController),
            _buildTextField("Phone Number", Icons.phone, _phoneNumberController),
            _buildTextField("Email", Icons.email, _emailController),
            _buildTextField("Code of the system", Icons.code, _systemCodeController),
            _buildPasswordField("Password", _passwordController, _isPasswordVisible, () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            }),
            _buildPasswordField("Confirm Password", _confirmPasswordController, _isConfirmPasswordVisible, () {
              setState(() {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              });
            }),
            SizedBox(height: 20),
            Center(
              child: Text(
                "By clicking the Register button, you agree to the public offer",
                style: TextStyle(color: Colors.blue, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: registerUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Register",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Back",
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          prefixIcon: Icon(icon, color: Colors.white),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, bool isVisible, VoidCallback toggleVisibility) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        obscureText: !isVisible,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          prefixIcon: Icon(Icons.lock, color: Colors.white),
          suffixIcon: IconButton(
            icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white),
            onPressed: toggleVisibility,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
