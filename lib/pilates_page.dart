import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PilatesPage extends StatefulWidget {
  @override
  _PilatesPageState createState() => _PilatesPageState();
}

class _PilatesPageState extends State<PilatesPage> {
  late VideoPlayerController _controller;
  late List<String> pilatesVideos = [
    'assets/pillate1.mp4',
    'assets/pillate2.mp4',
    'assets/pillates3.mp4',
  ];

  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(pilatesVideos[0])
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
          'Pilates',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              flex: 3,
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
            SizedBox(height: 20),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _playVideo(pilatesVideos[0]),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.cyanAccent, // Custom color for the tile
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Classical',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _playVideo(pilatesVideos[1]),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.cyanAccent, // Custom color for the tile
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Mat Pilates',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _playVideo(pilatesVideos[2]),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.cyanAccent, // Custom color for the tile
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Equipment pilates',
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
