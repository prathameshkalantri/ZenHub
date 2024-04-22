import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationPage extends StatelessWidget {
  final double latitude = 37.7749; // Example latitude
  final double longitude = -122.4194; // Example longitude

  Future<void> _openMaps() async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    String appleUrl = 'https://maps.apple.com/?sll=$latitude,$longitude';

    try {
      if (await canLaunch(googleUrl)) {
        await launch(googleUrl);
      } else if (await canLaunch(appleUrl)) {
        await launch(appleUrl);
      } else {
        throw 'Could not launch maps';
      }
    } on PlatformException catch (e) {
      print('Error launching maps: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nearby Locations',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _openMaps,
          child: Text('Open Maps'),
        ),
      ),
    );
  }
}



