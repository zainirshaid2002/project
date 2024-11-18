import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  String batteryCharge = "";
  String load1Power = "";
  String load2Power = "";
  String load1Source = ""; // PowerSource for Load 1
  String load2Source = ""; // PowerSource for Load 2

  String systemCode = "";
  String userId = "";

  @override
  void initState() {
    super.initState();

    // Ensure `SystemCode` and `userId` are received from `LoginScreen`
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, String>;
      systemCode = args['SystemCode'] ?? "";
      userId = args['userId'] ?? "";

      // Use `SystemCode` and `userId` to fetch data from the database
      databaseRef.child("system/$systemCode/User/$userId").onValue.listen((event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;
        if (data != null) {
          setState(() {
            batteryCharge = data['Battery']?['Battery1']?['BatteryCharge']?.toString() ?? "0";
            load1Power = data['Loads']?['Load1']?['PowerKw']?.toString() ?? "0";
            load2Power = data['Loads']?['Load2']?['PowerKw']?.toString() ?? "0";
            load1Source = data['Loads']?['Load1']?['PowerSource']?.toString() ?? "Unknown"; // Load 1 PowerSource
            load2Source = data['Loads']?['Load2']?['PowerSource']?.toString() ?? "Unknown"; // Load 2 PowerSource
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("SolGrid Sentry"),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            // Open the custom drawer
            _openCustomDrawer(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Image.asset(
              'assets/solgrid_logo.png',
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 80.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusCard("Battery", batteryCharge, ""),
                SizedBox(height: 10),
                _buildStatusCard("Load 1", "$load1Power kW", load1Source), // Using load1Source dynamically
                SizedBox(height: 10),
                _buildStatusCard("Load 2 (critical)", "$load2Power kW", load2Source), // Using load2Source dynamically
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openCustomDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          widthFactor: 0.8,
          heightFactor: 0.9,
          alignment: Alignment.centerLeft,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage('assets/image2.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.orange[400],
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Menu",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(65),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[400],
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.home, color: Colors.black54),
                              Text(
                                "Home",
                                style: TextStyle(color: Colors.black54, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/dashboard',
                                arguments: {'SystemCode': systemCode, 'userId': userId});
                          },
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[400],
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.person, color: Colors.black54),
                              Text(
                                "Profile",
                                style: TextStyle(color: Colors.black54, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/profile',
                                arguments: {'SystemCode': systemCode, 'userId': userId});
                          },
                        ),
                        Spacer(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[400],
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text(
                            "Logout",
                            style: TextStyle(color: Colors.black54, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusCard(String title, String value, String subtitle) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          if (subtitle.isNotEmpty)
            Text(
              subtitle,
              style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }
}
