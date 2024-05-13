import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class ReminderPage extends StatefulWidget {
  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  TimeOfDay _selectedTime = TimeOfDay.now();
  List<String> _daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  List<bool> _selectedDays = [
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones(); // Initialize time zones
    initializeNotifications();
  }

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _scheduleNotification(tz.TZDateTime scheduledTime) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'zenfit', // Replace with your channel ID
      'Workout Reminder', // Replace with your channel name
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Reminder',
      'This is your reminder',
      scheduledTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select Time:',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () => _selectTime(context),
              child: Text(
                'Select Time: ${_selectedTime.format(context)}',
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Select Frequency:',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 10.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _daysOfWeek.asMap().entries.map((entry) {
                final index = entry.key;
                final day = entry.value;
                return FilterChip(
                  label: Text(day),
                  selected: _selectedDays[index],
                  onSelected: (selected) {
                    setState(() {
                      _selectedDays[index] = selected;
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                final now = tz.TZDateTime.now(tz.local);
                final scheduledTime = tz.TZDateTime(
                  tz.local,
                  now.year,
                  now.month,
                  now.day,
                  _selectedTime.hour,
                  _selectedTime.minute,
                );

                _scheduleNotification(scheduledTime);

                // Schedule notifications for selected days
                for (int i = 0; i < _selectedDays.length; i++) {
                  if (_selectedDays[i]) {
                    final dayIndex = (i + 1) % 7; // Adjust day index
                    final day = tz.TZDateTime(
                      tz.local,
                      now.year,
                      now.month,
                      now.day + (dayIndex - now.weekday),
                      _selectedTime.hour,
                      _selectedTime.minute,
                    );
                    _scheduleNotification(day);
                  }
                }
              },
              child: Text('Save Reminder'),
            ),
          ],
        ),
      ),
    );
  }
}