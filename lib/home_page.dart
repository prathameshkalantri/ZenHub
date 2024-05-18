import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zenhub/workout_page.dart';
import 'package:zenhub/setting_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  int _selectedWorkouts = 0;


  int _selectedDay = DateTime.now().day; // Default to 1st day of the month
  int _selectedMonth = DateTime.now().month; // Default to current month
  int _selectedYear = DateTime.now().year; // Default to current year

  double _progress = 0;

  String? _userName;

  @override
  void initState() {
    super.initState();
    _getUserName();
    _fetchWorkoutDetails();
    fetchWorkoutsForSelectedWeek();
  }

  void _getUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userName = user.displayName;
      });
    }
  }

  Future<void> fetchWorkoutsForSelectedWeek() async {
    if (FirebaseAuth.instance.currentUser != null) {
      _progress = 0;
      int _completedWorkoutsForWeek = 0;
      // Get current user's UID
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // Calculate the start and end dates of the week based on the selected date
      DateTime selectedDate =
      DateTime(_selectedYear, _selectedMonth, _selectedDay);
      DateTime startOfWeek =
      selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
      DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

// Format the start and end dates as required for Firestore document ID
      String formattedStartOfWeek =
          "${startOfWeek.year}-${startOfWeek.month.toString().padLeft(2, '0')}-${startOfWeek.day.toString().padLeft(2, '0')}";
      String formattedEndOfWeek =
          "${endOfWeek.year}-${endOfWeek.month.toString().padLeft(2, '0')}-${endOfWeek.day.toString().padLeft(2, '0')}";

      // Reference to Firestore collection
      CollectionReference workoutsCollection =
      FirebaseFirestore.instance.collection('workouts');

      // Query workouts for the selected week
      QuerySnapshot querySnapshot = await workoutsCollection
          .doc(uid)
          .collection('dates')
          .where(FieldPath.documentId,
          isGreaterThanOrEqualTo: formattedStartOfWeek)
          .where(FieldPath.documentId, isLessThanOrEqualTo: formattedEndOfWeek)
          .get();

      // Process query results
      if (querySnapshot.docs.isNotEmpty) {
        print('Workouts for the week:');
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          // Extract workout data
          int? selectedWorkout = doc['selectedWorkout'];
          _completedWorkoutsForWeek += selectedWorkout!;

          // Print or process workout data as needed
          print('Selected Workout: $selectedWorkout, Date: ${doc.id}}');
        }
      } else {
        print('No workouts found for the selected week');
      }

      setState(() {
        print('Before progress: $_completedWorkoutsForWeek');
        _progress = (_completedWorkoutsForWeek / (12 * 7) ) * 100;
      });
    }
  }

  Future<void> _fetchWorkoutDetails() async {
    fetchWorkoutsForSelectedWeek();
    if (FirebaseAuth.instance.currentUser != null) {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      DateTime currentDate =
      DateTime(_selectedYear, _selectedMonth, _selectedDay);

// Format the date as required for Firestore document ID
      String formattedDate =
          "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";

      CollectionReference workoutsCollection =
      FirebaseFirestore.instance.collection('workouts');
      DocumentReference workoutDocument =
      workoutsCollection.doc(uid).collection('dates').doc(formattedDate);
      DocumentSnapshot snapshot = await workoutDocument.get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          int? selectedWorkout = data['selectedWorkout'];
          print('Selected Workout: $selectedWorkout');
          setState(() {
            _selectedWorkouts = selectedWorkout!;
          });
        } else {
          print('Data is null');
        }
      } else {
        print('Document does not exist for the date: $formattedDate');
        setState(() {
          _selectedWorkouts = 0; // setting to 0
        });
      }
    }
  }

  void _updateInFirebase(int workoutNumber) {
    if (FirebaseAuth.instance.currentUser != null) {
      // Get current user's UID
      String uid = FirebaseAuth.instance.currentUser!.uid;

// Get current date
      DateTime currentDate =
      DateTime(_selectedYear, _selectedMonth, _selectedDay);

// Format the date as required for Firestore document ID
      String formattedDate =
          "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";

      // Reference to Firestore collection
      CollectionReference workoutsCollection =
      FirebaseFirestore.instance.collection('workouts');

      // Reference to document with the current user's UID as parent and formatted date as ID
      DocumentReference workoutDocument =
      workoutsCollection.doc(uid).collection('dates').doc(formattedDate);

      print('workoutNumber is $workoutNumber');

      // Data to be stored
      Map<String, dynamic> data = {
        'selectedWorkout': workoutNumber,
      };

      // Set the data under the document
      workoutDocument.set(data, SetOptions(merge: true)).then((value) {
        print("Workout data stored successfully!");
      }).catchError((error) {
        print("Failed to store workout data: $error");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalWorkouts = 12;
    int finishedWorkouts =
        _selectedWorkouts; // Increment by 1 to match selected workout
    int pendingWorkouts = totalWorkouts - finishedWorkouts;
    int timeSpent = finishedWorkouts * 20;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
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
          Center(
            child: Text(
              "Let's check your activity",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    height: 165, // Adjust the height as needed
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.cyan, // Set color to cyan
                              size: 30,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Finished Workouts: $finishedWorkouts',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: 74, // Adjust the height as needed
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: Colors.cyan, // Set color to cyan
                                  size: 24,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Time Spent: $timeSpent minutes',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        height: 74, // Adjust the height as needed
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.access_alarm,
                                  color: Colors.cyan, // Set color to cyan
                                  size: 24,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Pending Workouts: $pendingWorkouts',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // New dropdown menu for selecting day, month, and year
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                // Dropdown menu for day
                DropdownButton<int>(
                  value: _selectedDay,
                  items: List.generate(31, (index) {
                    return DropdownMenuItem<int>(
                      value: index + 1,
                      child: Text('${index + 1}'),
                    );
                  }),
                  onChanged: (value) {
                    setState(() {
                      _selectedDay = value!;
                      _fetchWorkoutDetails();
                    });
                  },
                ),
                SizedBox(width: 8),
                // Dropdown menu for month
                DropdownButton<int>(
                  value: _selectedMonth,
                  items: List.generate(12, (index) {
                    return DropdownMenuItem<int>(
                      value: index + 1,
                      child: Text('${_getMonthName(index + 1)}'),
                    );
                  }),
                  onChanged: (value) {
                    setState(() {
                      _selectedMonth = value!;
                      _fetchWorkoutDetails();
                    });
                  },
                ),
                SizedBox(width: 8),
                // Dropdown menu for year
                DropdownButton<int>(
                  value: _selectedYear,
                  items: List.generate(10, (index) {
                    return DropdownMenuItem<int>(
                      value: 2022 + index,
                      child: Text('${2022 + index}'),
                    );
                  }),
                  onChanged: (value) {
                    setState(() {
                      _selectedYear = value!;
                      _fetchWorkoutDetails();
                    });
                  },
                ),

                SizedBox(width: 8),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Display progress
          Text(
            'Progress: ${_progress.toStringAsFixed(2)}%',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 16.0), // Add padding on both sides
            child: SizedBox(
              height: 10, // Adjust the height as needed
              child: LinearProgressIndicator(
                value: _progress /
                    100, // Convert percentage to a value between 0 and 1
                color: Colors.cyan, // Set the color of the progress bar
              ),
            ),
          ),
          SizedBox(height:15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Image.asset(
                        'assets/fitness4.jpg', // Replace with your image path
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Image.asset(
                        'assets/fitness3.jpg', // Replace with your image path
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.cyan,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:
            // Do nothing since we are already on the HomePage
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WorkoutPage()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingPage()),
              );
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            // Set color to cyan when current index is 0
            activeIcon: Icon(Icons.home, color: Colors.cyan),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workout',
            // Set color to cyan when current index is 1
            activeIcon: Icon(Icons.fitness_center, color: Colors.cyan),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            // Set color to cyan when current index is 2
            activeIcon: Icon(Icons.settings, color: Colors.cyan),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Show a dropdown menu to select workouts
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Select Workout'),
                content: DropdownButton<int>(
                  value: _selectedWorkouts == 0
                      ? 0
                      : _selectedWorkouts -
                      1, // _selectedWorkouts should be one less than actual to display in the list
                  items: List.generate(totalWorkouts, (index) {
                    return DropdownMenuItem<int>(
                      value: index,
                      child: Text('Workout ${index + 1}'),
                    );
                  }),
                  onChanged: (value) {
                    setState(() {
                      _selectedWorkouts = value! + 1;
                      _updateInFirebase(_selectedWorkouts);
                      fetchWorkoutsForSelectedWeek();
                    });
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              );
            },
          );
        },
        label: Text('Select Workout',
        style: TextStyle(color: Colors.white),),
        icon: Icon(Icons.fitness_center, color: Colors.white,),
        backgroundColor: Colors.cyan,
      ),
    );
  }

  // Function to get the name of the month from its index
  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
}








