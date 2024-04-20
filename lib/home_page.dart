import 'package:flutter/material.dart';
import 'package:zenhub/workout_page.dart';
import 'package:zenhub/setting_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Text(
            'Welcome',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Let's check your activity",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (context) => HomePage()),
                // );
              },
            ),
            IconButton(
              icon: Icon(Icons.fitness_center),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WorkoutPage()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
