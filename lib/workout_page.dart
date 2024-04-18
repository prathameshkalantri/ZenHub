import 'package:flutter/material.dart';

class WorkoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout'),
      ),
      body: Center(
        child: Text(
          'This is the Workout Page',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
