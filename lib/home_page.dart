// import 'package:flutter/material.dart';
// import 'package:zenhub/workout_page.dart';
// import 'package:zenhub/setting_page.dart';
//
// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   int _currentIndex = 0;
//   int _selectedWorkouts = 0;
//   int _selectedDay = 1; // Default to 1st day of the month
//   int _selectedMonth = DateTime.now().month; // Default to current month
//   int _selectedYear = DateTime.now().year; // Default to current year
//
//   @override
//   Widget build(BuildContext context) {
//     int totalWorkouts = 12;
//     int finishedWorkouts = _selectedWorkouts + 1; // Increment by 1 to match selected workout
//     int pendingWorkouts = totalWorkouts - finishedWorkouts;
//     int timeSpent = finishedWorkouts * 20;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Home',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         automaticallyImplyLeading: false,
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SizedBox(height: 20),
//           Text(
//             'Welcome',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Center(
//             child: Text(
//               "Let's check your activity",
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           SizedBox(height: 20),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16.0),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: Container(
//                     height: 165, // Adjust the height as needed
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12.0),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.5),
//                           spreadRadius: 2,
//                           blurRadius: 5,
//                           offset: Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.check_circle,
//                               color: Colors.cyan, // Set color to cyan
//                               size: 30,
//                             ),
//                             SizedBox(width: 8),
//                             Expanded(
//                               child: Text(
//                                 'Finished Workouts: $finishedWorkouts',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     children: [
//                       Container(
//                         height: 74, // Adjust the height as needed
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12.0),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.5),
//                               spreadRadius: 2,
//                               blurRadius: 5,
//                               offset: Offset(0, 3),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.access_time,
//                                   color: Colors.cyan, // Set color to cyan
//                                   size: 24,
//                                 ),
//                                 SizedBox(width: 8),
//                                 Expanded(
//                                   child: Text(
//                                     'Time Spent: $timeSpent minutes',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 16),
//                       Container(
//                         height: 74, // Adjust the height as needed
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12.0),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.5),
//                               spreadRadius: 2,
//                               blurRadius: 5,
//                               offset: Offset(0, 3),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.access_alarm,
//                                   color: Colors.cyan, // Set color to cyan
//                                   size: 24,
//                                 ),
//                                 SizedBox(width: 8),
//                                 Expanded(
//                                   child: Text(
//                                     'Pending Workouts: $pendingWorkouts',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 20),
//           // New dropdown menu for selecting day, month, and year
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Row(
//               children: [
//                 // Dropdown menu for day
//                 DropdownButton<int>(
//                   value: _selectedDay,
//                   items: List.generate(31, (index) {
//                     return DropdownMenuItem<int>(
//                       value: index + 1,
//                       child: Text('${index + 1}'),
//                     );
//                   }),
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedDay = value!;
//                     });
//                   },
//                 ),
//                 SizedBox(width: 8),
//                 // Dropdown menu for month
//                 DropdownButton<int>(
//                   value: _selectedMonth,
//                   items: List.generate(12, (index) {
//                     return DropdownMenuItem<int>(
//                       value: index + 1,
//                       child: Text('${_getMonthName(index + 1)}'),
//                     );
//                   }),
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedMonth = value!;
//                     });
//                   },
//                 ),
//                 SizedBox(width: 8),
//                 // Dropdown menu for year
//                 DropdownButton<int>(
//                   value: _selectedYear,
//                   items: List.generate(10, (index) {
//                     return DropdownMenuItem<int>(
//                       value: 2022 + index,
//                       child: Text('${2022 + index}'),
//                     );
//                   }),
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedYear = value!;
//                     });
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         backgroundColor: Colors.white,
//         selectedItemColor: Colors.cyan,
//         unselectedItemColor: Colors.grey,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//           switch (index) {
//             case 0:
//             // Do nothing since we are already on the HomePage
//               break;
//             case 1:
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => WorkoutPage()),
//               );
//               break;
//             case 2:
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => SettingPage()),
//               );
//               break;
//           }
//         },
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//             // Set color to cyan when current index is 0
//             activeIcon: Icon(Icons.home, color: Colors.cyan),
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.fitness_center),
//             label: 'Workout',
//             // Set color to cyan when current index is 1
//             activeIcon: Icon(Icons.fitness_center, color: Colors.cyan),
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings),
//             label: 'Settings',
//             // Set color to cyan when current index is 2
//             activeIcon: Icon(Icons.settings, color: Colors.cyan),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           // Show a dropdown menu to select workouts
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: Text('Select Workout'),
//                 content: DropdownButton<int>(
//                   value: _selectedWorkouts,
//                   items: List.generate(totalWorkouts, (index) {
//                     return DropdownMenuItem<int>(
//                       value: index,
//                       child: Text('Workout ${index + 1}'),
//                     );
//                   }),
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedWorkouts = value!;
//                     });
//                     Navigator.of(context).pop(); // Close the dialog
//                   },
//                 ),
//               );
//             },
//           );
//         },
//         label: Text('Select Workout'),
//         icon: Icon(Icons.fitness_center),
//         backgroundColor: Colors.cyan,
//       ),
//     );
//   }
//
//   // Function to get the name of the month from its index
//   String _getMonthName(int month) {
//     switch (month) {
//       case 1:
//         return 'January';
//       case 2:
//         return 'February';
//       case 3:
//         return 'March';
//       case 4:
//         return 'April';
//       case 5:
//         return 'May';
//       case 6:
//         return 'June';
//       case 7:
//         return 'July';
//       case 8:
//         return 'August';
//       case 9:
//         return 'September';
//       case 10:
//         return 'October';
//       case 11:
//         return 'November';
//       case 12:
//         return 'December';
//       default:
//         return '';
//     }
//   }
// }
//




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
  int _selectedDay = 1; // Default to 1st day of the month
  int _selectedMonth = DateTime.now().month; // Default to current month
  int _selectedYear = DateTime.now().year; // Default to current year

  String? _userName;

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  void _getUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userName = user.displayName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalWorkouts = 12;
    int finishedWorkouts = _selectedWorkouts + 1; // Increment by 1 to match selected workout
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
          _userName != null
              ? Text(
            'Hello $_userName',
            style: TextStyle(
              fontSize: 20,
            ),
          )
              : SizedBox.shrink(),
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
                    });
                  },
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
                  value: _selectedWorkouts,
                  items: List.generate(totalWorkouts, (index) {
                    return DropdownMenuItem<int>(
                      value: index,
                      child: Text('Workout ${index + 1}'),
                    );
                  }),
                  onChanged: (value) {
                    setState(() {
                      _selectedWorkouts = value!;
                    });
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              );
            },
          );
        },
        label: Text('Select Workout'),
        icon: Icon(Icons.fitness_center),
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
