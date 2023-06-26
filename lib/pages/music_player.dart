import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicPlayer extends StatefulWidget {
  final String songPath;

  const MusicPlayer({Key? key, required this.songPath}) : super(key: key);

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}
enum AudioPlayerState {
  STOPPED,
  PLAYING,
  PAUSED,
}

class _MusicPlayerState extends State<MusicPlayer> {
  late AudioPlayer audioPlayer;
  AudioPlayerState audioPlayerState = AudioPlayerState.STOPPED;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioPlayer.onPlayerStateChanged.listen((AudioPlayerState state) {
      setState(() {
        audioPlayerState = state;
      });
    } as void Function(PlayerState event)?);
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> playMusic() async {
    await audioPlayer.play(widget.songPath, isLocal: true);
  }

  Future<void> pauseMusic() async {
    await audioPlayer.pause();
  }

  Future<void> stopMusic() async {
    await audioPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.play_arrow),
              onPressed: () {
                playMusic();
              },
            ),
            IconButton(
              icon: Icon(Icons.pause),
              onPressed: () {
                pauseMusic();
              },
            ),
            IconButton(
              icon: Icon(Icons.stop),
              onPressed: () {
                stopMusic();
              },
            ),
            Text(
              'Player State: $audioPlayerState',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
