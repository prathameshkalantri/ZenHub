import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'reminder_page.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isEditMode = false;
  XFile? _image;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
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
        ],
      ),
    );
  }
}
