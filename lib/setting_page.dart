import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'reminder_page.dart';
import 'workout_page.dart';
import 'home_page.dart';
import 'location.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isEditMode = false;
  XFile? _image;
  String? newPassword;
  String? confirmPassword;
  String? _profilePhotoURL;
  String? _username;

  @override
  void initState() {
    super.initState();
    _preloadProfileImage(); // Preload profile image when the page initializes
    _getProfilePhotoURL();
    _fetchUsername();
  }

  // Preload profile image in the background
  void _preloadProfileImage() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
      DocumentSnapshot snapshot = await usersRef.doc(user.uid).get();
      String? profilePhotoURL = snapshot['profile_photo_url'];
      if (profilePhotoURL != null) {
        // Load profile photo in the background
        await precacheImage(NetworkImage(profilePhotoURL), context);
      }
    }
  }

  void _getProfilePhotoURL() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
      DocumentSnapshot snapshot = await usersRef.doc(user.uid).get();
      setState(() {
        _profilePhotoURL = snapshot['profile_photo_url'];
      });
    }
  }

  void _fetchUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        setState(() {
          _username = userDoc['username'];
        });
      } catch (e) {
        print('Error fetching username: $e');
      }
    }
  }

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  void _showImagePicker(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await showModalBottomSheet<XFile>(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('Take a photo'),
              onTap: () async {
                Navigator.pop(context, await picker.pickImage(source: ImageSource.camera));
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Choose from gallery'),
              onTap: () async {
                Navigator.pop(context, await picker.pickImage(source: ImageSource.gallery));
              },
            ),
          ],
        );
      },
    );

    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });

      try {
        // Display a placeholder while loading the image
        setState(() {
          _profilePhotoURL = null;
        });

        File imageFile = File(pickedFile.path);
        String fileName = 'profile_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final Reference storageRef = FirebaseStorage.instance.ref().child('profile_images/$fileName');
        UploadTask uploadTask = storageRef.putFile(imageFile);

        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
        String downloadURL = await taskSnapshot.ref.getDownloadURL();

        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
          DocumentReference userDocRef = usersRef.doc(user.uid);

          await userDocRef.update({'profile_photo_url': downloadURL});

          setState(() {
            _profilePhotoURL = downloadURL;
            _image = null; // Clear the _image variable after updating the profile photo URL
          });

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Image uploaded successfully'),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('User not signed in'),
          ));
        }
      } catch (e) {
        print('Error uploading image: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error uploading image'),
        ));
      }
    }
  }

  void _changePassword() async {
    String? currentPassword = '';

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
                  // Passwords match, update the password
                  // Your password update logic here
                } else {
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

  void _logout() {
    Navigator.pushReplacementNamed(context, '/signin');
  }

  void _locateNearbyLocations() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NearbyLocationsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
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
              // Conditionally render the profile image based on whether the image is loaded or still loading
              _profilePhotoURL != null
                  ? CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(_profilePhotoURL!),
              )
                  : _image != null
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
              // Conditionally render the profile image based on whether the image is loaded or still loading
              _profilePhotoURL != null
                  ? CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(_profilePhotoURL!),
              )
                  : _image != null
                  ? CircleAvatar(
                radius: 50,
                backgroundImage: FileImage(File(_image!.path)),
              )
                  : CircleAvatar(
                radius: 50,
                child: CircularProgressIndicator(), // Placeholder for the profile image while loading
              ),
              SizedBox(height: 20),
              _username != null
                  ? Text(
                _username!,
                style: TextStyle(fontSize: 20),
              )
                  : CircularProgressIndicator(),
            ],
          ),
          SizedBox(height: 20),
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
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Change Password'),
            onTap: _changePassword,
          ),
          SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Locate Nearby Locations'),
            onTap: _locateNearbyLocations,
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

class NearbyLocationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Locations'),
      ),
      body: Center(
        child: Text('Display nearby locations on Google Maps here'),
      ),
    );
  }
}