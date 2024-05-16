import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
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
  int _currentIndex = 2;
  bool isEditMode = false;
  XFile? _image;
  String? newPassword;
  String? confirmPassword;
  String? _profilePhotoURL; // Add this variable to store the profile photo URL
  String? _username; // Add this variable to store the fetched username

  @override
  void initState() {
    super.initState();
    _getProfilePhotoURL();
    _fetchUsername(); // Call the method to fetch the username when the page initializes
  }

  // Method to fetch the profile photo URL from Firestore
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

  // Method to fetch the username from Firestore
  void _fetchUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Fetch username from Firestore
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
        File imageFile = File(pickedFile.path);
        String fileName = 'profile_image_${DateTime.now().millisecondsSinceEpoch}.jpg';

        // Create a reference to the location you want to upload to in Firebase Storage
        final Reference storageRef = FirebaseStorage.instance.ref().child('profile_images/$fileName');

        // Upload the file to Firebase Storage
        UploadTask uploadTask = storageRef.putFile(imageFile);

        // Get the download URL of the uploaded image
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

        String downloadURL = await taskSnapshot.ref.getDownloadURL();

        // Update the user's profile photo URL in Firestore
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // Assuming you have a Firestore collection named 'users' and a document for each user
          CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
          DocumentReference userDocRef = usersRef.doc(user.uid);

          // Update the 'profile_photo_url' field in the user document
          await userDocRef.update({'profile_photo_url': downloadURL});

          // Update the background image URL
          setState(() {
            _profilePhotoURL = downloadURL;
          });

          // Show a message indicating the image was uploaded successfully
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Image uploaded successfully'),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('User not signed in'),
          ));
        }
      } catch (e) {
        // Handle any errors that occur during the upload process
        print('Error uploading image: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error uploading image'),
        ));
      }
    }
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
    // Navigate to sign-in page
    Navigator.pushReplacementNamed(context, '/signin');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
                  : _profilePhotoURL != null
                  ? CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(_profilePhotoURL!),
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
              _profilePhotoURL != null
                  ? CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(_profilePhotoURL!),
              )
                  : CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/image2.jpg'),
              ),
              SizedBox(height: 20),
              _username != null // Check if username is fetched
                  ? Text(
                _username!, // Display the fetched username
                style: TextStyle(fontSize: 20),
              )
                  : CircularProgressIndicator(), // Show a loading indicator while fetching username
            ],
          ),
          SizedBox(height: 20),
          // Add reminder option below the username
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Reminder',),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReminderPage(title: 'Reminder',)),
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
                setState(() {
                  _currentIndex = 0; // Update current index
                });
              },
              color: _currentIndex == 0 ? Colors.cyan : null, // Highlight if this is the selected item
            ),
            IconButton(
              icon: Icon(Icons.fitness_center),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/workout');
                setState(() {
                  _currentIndex = 1; // Update current index
                });
              },
              color: _currentIndex == 1 ? Colors.cyan : null, // Highlight if this is the selected item
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                // Do nothing since we are already on the SettingPage
              },
              color: _currentIndex == 2 ? Colors.cyan : null, // Highlight if this is the selected item
            ),
          ],
        ),
      ),
    );
  }
}



