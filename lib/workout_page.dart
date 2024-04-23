import 'package:flutter/material.dart';
import 'yoga_page.dart';
import 'pilates_page.dart';
import 'full_body_page.dart';
import 'stretching_page.dart';
import 'setting_page.dart'; // Import SettingPage
import 'home_page.dart'; // Import HomePage

class ExerciseOption extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const ExerciseOption({
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20),
        title: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(width: 10),
            Image.asset(
              imagePath,
              width: 160, // Adjust image width as needed
              height: 100, // Adjust image height as needed
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

class WorkoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout'),
        automaticallyImplyLeading: false, // Remove the back button
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'This is the Workout Page',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 120, // Adjust height as needed
              child: ExerciseOption(
                title: 'Yoga',
                imagePath: 'assets/yoga.jpg', // Add your image path
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => YogaPage()));
                },
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 120, // Adjust height as needed
              child: ExerciseOption(
                title: 'Pilates',
                imagePath: 'assets/pillates.jpg', // Add your image path
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PilatesPage()));
                },
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 120, // Adjust height as needed
              child: ExerciseOption(
                title: 'Full Body',  //full body exercise
                imagePath: 'assets/fullbody.jpg', // Add your image path
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FullBodyPage()));
                },
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 120, // Adjust height as needed
              child: ExerciseOption(
                title: 'Stretching',
                imagePath: 'assets/stretching.jpg', // Add your image path
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StretchingPage()));
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            IconButton(
              icon: Icon(Icons.fitness_center),
              onPressed: () {
                // Do nothing since we are already on the WorkoutPage
              },
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/setting');
              },
            ),
          ],
        ),
      ),
    );
  }
}

