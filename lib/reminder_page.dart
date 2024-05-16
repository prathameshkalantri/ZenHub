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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            Text(
              'Scheduled Date and Time: $scheduleTime',
              style: TextStyle(fontSize: 16),
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
