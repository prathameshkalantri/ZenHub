import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import Services for rootBundle
import 'yoga_page.dart';
import 'pilates_page.dart';
import 'full_body_page.dart';
import 'stretching_page.dart';
import 'setting_page.dart'; // Import SettingPage
import 'home_page.dart'; // Import HomePage

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  precacheImages(); // Preload and cache images

  runApp(MyApp());
}

void precacheImages() async {
  // Load images from assets
  final yogaImage = await loadAssetImage('assets/yoga.jpg');
  final pilatesImage = await loadAssetImage('assets/pillates.jpg');
  final fullBodyImage = await loadAssetImage('assets/fullbody.jpg');
  final stretchingImage = await loadAssetImage('assets/stretching.jpg');

  // Create a dummy BuildContext using GlobalKey
  final GlobalKey dummyKey = GlobalKey();
  final BuildContext dummyContext = dummyKey.currentContext!;

  // Preload and cache images using the dummy context
  precacheImage(yogaImage, dummyContext);
  precacheImage(pilatesImage, dummyContext);
  precacheImage(fullBodyImage, dummyContext);
  precacheImage(stretchingImage, dummyContext);
}

Future<ImageProvider> loadAssetImage(String path) async {
  final ByteData data = await rootBundle.load(path);
  return MemoryImage(data.buffer.asUint8List());
}

class ExerciseOption extends StatelessWidget {
  final String title;
  final ImageProvider image;
  final VoidCallback onTap;

  const ExerciseOption({
    required this.title,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white, // Set the color of the card to white
      elevation: 1, // Add elevation for shadow effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20),
        title: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(color: Colors.cyan, fontSize: 20),
              ),
            ),
            SizedBox(width: 10),
            Image(
              image: image,
              width: 160, // Adjust image width as needed
              height: 100, // Adjust image height as needed
              fit: BoxFit.cover, // Ensure the image covers the space
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}


class WorkoutPage extends StatefulWidget {
  @override
  _WorkoutPageState createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  int _currentIndex = 1; // Initially set to index 1 for WorkoutPage

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Workout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false, // Remove the back button
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            SizedBox(
              height: 120, // Adjust height as needed
              child: ExerciseOption(
                title: 'Yoga',
                image: AssetImage('assets/yoga.jpg'), // Add your image path
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
                image: AssetImage('assets/pillates.jpg'), // Add your image path
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
                image: AssetImage('assets/fullbody.jpg'), // Add your image path
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FullBodyPage()));
                },
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 120, // Adjust height as needed
              child: ExerciseOption(
                title: 'Streching',
                image: AssetImage('assets/stretching.jpg'), // Add your image path
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StretchingPage()));
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/setting');
              break;
          }
        },
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            activeIcon: Icon(Icons.home, color: Colors.cyan),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workout',
            activeIcon: Icon(Icons.fitness_center, color: Colors.cyan),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            activeIcon: Icon(Icons.settings, color: Colors.cyan),
          ),
        ],
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness App',
      initialRoute: '/workout',
      routes: {
        '/workout': (context) => WorkoutPage(),
        '/home': (context) => HomePage(),
        '/setting': (context) => SettingPage(),
      },
    );
  }
}
