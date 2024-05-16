import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
as datatTimePicker;
import 'package:permission_handler/permission_handler.dart';
import 'notification.dart';


DateTime scheduleTime = DateTime.now();

class ReminderPage extends StatefulWidget {
  const ReminderPage({Key? key, required this.title});

  final String title;

  @override
  State<ReminderPage> createState() => _MyReminderPage();
}

class _MyReminderPage extends State<ReminderPage> {
  bool isNotificationEnabled = false;
  late DateTime selectedDateTime; // Define selectedDateTime here

  @override
  void initState() {
    super.initState();
    checkNotificationPermission();
    selectedDateTime = scheduleTime;
  }

  void checkNotificationPermission() async {
    PermissionStatus notificationStatus =
    await Permission.notification.status;
    setState(() {
      isNotificationEnabled = notificationStatus.isGranted;
    });
  }

  void requestNotificationPermission() async {
    PermissionStatus notificationStatus =
    await Permission.notification.request();
    if (notificationStatus.isGranted) {
      setState(() {
        isNotificationEnabled = notificationStatus.isGranted;
      });
    } else {
      setState(() {
        isNotificationEnabled = notificationStatus.isGranted;
      });
    }
  }

  void showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reminder set successfully!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: isNotificationEnabled
            ? Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // SizedBox(height: 10,),
            Image.asset(
              'assets/reminder1.jpg', // Replace with your image path
              height: 350, // Adjust height as needed
              width: double.infinity, // Take full width
              fit: BoxFit.cover, // Cover the area
            ),
            // SizedBox(height: 10,),
            DatePickerTxt(
              onDateTimeChanged: (date) {
                setState(() {
                  selectedDateTime = date;
                });
              },
            ),
            SizedBox(height: 20),
            ScheduleBtn(
              onSchedule: () {
                debugPrint('Notification Scheduled for $selectedDateTime');
                NotificationService().scheduleNotification(
                  title: 'Workout Time!',
                  body: '$selectedDateTime',
                  scheduledNotificationDateTime: selectedDateTime,
                );
                setState(() {
                  scheduleTime = selectedDateTime;
                });
                showSnackbar(context); // Show snackbar after scheduling
              },
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.all(20), // Adjust margin as needed
              decoration: BoxDecoration(
                color: Colors.white, // Set the color to white
                borderRadius: BorderRadius.circular(12), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Shadow color
                    spreadRadius: 3, // Spread radius
                    blurRadius: 7, // Blur radius
                    offset: Offset(0, 3), // Offset from the top
                  ),
                ],
              ),
              child: ListTile(
                title: Text(
                  'Scheduled Date and Time:',
                  style: TextStyle(fontSize: 16),
                ),
                subtitle: Text(
                  '${scheduleTime.year}-${scheduleTime.month.toString().padLeft(2, '0')}-${scheduleTime.day.toString().padLeft(2, '0')} ${scheduleTime.hour.toString().padLeft(2, '0')}:${scheduleTime.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(fontSize: 20, color: Colors.cyan, fontWeight: FontWeight.bold),
                ),
                trailing: Icon(Icons.schedule), // Optionally add an icon
              ),
            ),

          ],
        )
            : Column(
          children: [
            Text('Notification Permissions need to be granted!'),
            ElevatedButton(
              onPressed: () {
                requestNotificationPermission();
              },
              child: Text('Request Notification Permissions'),
            ),
          ],
        ),
      ),
    );
  }
}

class DatePickerTxt extends StatefulWidget {
  final void Function(DateTime) onDateTimeChanged;

  const DatePickerTxt({
    Key? key,
    required this.onDateTimeChanged,
  }) : super(key: key);

  @override
  State<DatePickerTxt> createState() => _DatePickerTxtState();
}

class _DatePickerTxtState extends State<DatePickerTxt> {
  late DateTime selectedDateTime;

  @override
  void initState() {
    super.initState();
    selectedDateTime = scheduleTime;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '',
          style: TextStyle(color: Colors.blue),
        ),
        SizedBox(height: 15),
        Container( // Wrap the button with Container
          width: 300, // Set the desired width
          child: OutlinedButton(
            onPressed: () {
              datatTimePicker.DatePicker.showDateTimePicker(
                context,
                showTitleActions: true,
                onChanged: (date) {
                  setState(() {
                    selectedDateTime = date;
                    widget.onDateTimeChanged(date); // Pass selected date time to parent widget
                  });
                },
                onConfirm: (date) {
                  setState(() {
                    selectedDateTime = date;
                    widget.onDateTimeChanged(date); // Pass selected date time to parent widget
                  });
                },
              );
            },
            child: Text('Choose Date and Time'),
          ),
        ),
      ],
    );
  }
}

class ScheduleBtn extends StatelessWidget {
  final VoidCallback onSchedule;

  const ScheduleBtn({
    Key? key,
    required this.onSchedule,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.cyanAccent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onSchedule,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(
            'Set Reminder',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}