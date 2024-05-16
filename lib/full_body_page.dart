import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullBodyPage extends StatefulWidget {
  @override
  _FullBodyPageState createState() => _FullBodyPageState();
}

class _FullBodyPageState extends State<FullBodyPage> {
  late VideoPlayerController _controller;
  late List<String> fullBodyVideos = [
    'assets/fullbody2.mp4',
    'assets/fullbody3.mp4',
    'assets/fullbody4.mp4',
  ];

  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(fullBodyVideos[0])
      ..initialize().then((_) {
        setState(() {});
      });

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _playVideo(String videoPath) {
    _controller = VideoPlayerController.asset(videoPath)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _isPlaying = true;
      });
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  void _seekToRelativePosition(double position) {
    final duration = _controller.value.duration;
    final newPosition = duration * position;
    _controller.seekTo(newPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Full Body',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 80), // Adjusted padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              flex: 3, // Increased height of the video display screen
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    VideoPlayer(_controller),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(Icons.fast_rewind),
                          onPressed: () {
                            _seekToRelativePosition(-0.1);
                          },
                        ),
                        IconButton(
                          icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                          onPressed: _togglePlayPause,
                        ),
                        IconButton(
                          icon: Icon(Icons.fast_forward),
                          onPressed: () {
                            _seekToRelativePosition(0.1);
                          },
                        ),
                      ],
                    ),
                    VideoProgressIndicator(
                      _controller,
                      allowScrubbing: true,
                      padding: EdgeInsets.only(bottom: 8),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20), // Add spacing between video player and buttons
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _playVideo(fullBodyVideos[0]),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.cyanAccent, // Custom color for the tile
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Squats',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // Add spacing between tiles
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _playVideo(fullBodyVideos[1]),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.cyanAccent, // Custom color for the tile
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Push Ups',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // Add spacing between tiles
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _playVideo(fullBodyVideos[2]),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.cyanAccent, // Custom color for the tile
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Pull Ups',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
