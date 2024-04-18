import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'reminder_page.dart';
import 'dart:io';
import 'workout_page.dart'; // Import WorkoutPage
import 'home_page.dart'; // Import HomePage
import 'package:firebase_auth/firebase_auth.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isEditMode = false;
  XFile? _image;
  String? newPassword;
  String? confirmPassword;

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  Future<void> _showImagePicker(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Camera'),
                onTap: () {
                  _getImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () {
                  _getImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to handle logout
  void _logout() {
    // Navigate to sign-in page
    Navigator.pushReplacementNamed(context, '/signin');
  }

  // Function to handle changing the password
  void _changePassword() async {
    String? currentPassword = '';

    // Show dialog to input current password
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Current Password'),
                onChanged: (value) => currentPassword = value,
                obscureText: true,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'New Password'),
                onChanged: (value) => newPassword = value,
                obscureText: true,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Confirm New Password'),
                onChanged: (value) => confirmPassword = value,
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (newPassword == confirmPassword) {
                  try {
                    await FirebaseAuth.instance.currentUser!.updatePassword(newPassword!);
                    // Password updated successfully
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Password updated successfully!'),
                    ));
                  } catch (error) {
                    // Failed to update password
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Failed to update password!'),
                    ));
                  }
                } else {
                  // New passwords do not match
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('New passwords do not match!'),
                  ));
                }
                Navigator.pop(context);
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        automaticallyImplyLeading: false, // Hide the back button
        actions: [
          IconButton(
            icon: Icon(isEditMode ? Icons.done : Icons.edit),
            onPressed: () {
              setState(() {
                isEditMode = !isEditMode;
              });
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          isEditMode
              ? Column(
            children: [
              _image != null
                  ? CircleAvatar(
                radius: 50,
                backgroundImage: FileImage(File(_image!.path)),
              )
                  : CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/image2.jpg'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _showImagePicker(context),
                child: Text('Change Photo'),
              ),
            ],
          )
              : Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/image2.jpg'),
              ),
              SizedBox(height: 20),
              Text(
                'Username',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          SizedBox(height: 20),
          // Add reminder option below the username
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Reminder'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReminderPage()),
              );
            },
          ),
          SizedBox(height: 20),
          // Add Change Password button
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Change Password'),
            onTap: _changePassword,
          ),
          SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: _logout,
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
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            IconButton(
              icon: Icon(Icons.fitness_center),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/workout');
              },
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                // Do nothing since we are already on the SettingPage
              },
            ),
          ],
        ),
      ),
    );
  }
}
