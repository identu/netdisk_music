import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:netdisk_music/provider/music_play_provider.dart';

class MusicPlayer extends StatelessWidget {
  final String songPath;

  const MusicPlayer({Key? key, required this.songPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
        gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
        Colors.green.shade800.withOpacity(0.8),
    Colors.black12.withOpacity(0.6),
    ],
    ),
    ),
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Music Player'),
        backgroundColor: Colors.transparent,
        // Set app bar background color to transparent
        elevation: 0, // Remove app bar elevation
      ),
      backgroundColor: Colors.transparent,
      body: Consumer<AudioPlayerProvider>(
        builder: (context, audioPlayerProvider, _) {
          final audioPlayerState = audioPlayerProvider.audioPlayerState;
          final currentPosition = audioPlayerProvider.currentPosition;
          final totalDuration = audioPlayerProvider.totalDuration;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Player State: $audioPlayerState',
                    style: TextStyle(fontSize: 18,color: Colors.white70),
                  ),
                ),
              ),
              Slider(
                value: currentPosition.inMilliseconds.toDouble(),
                min: 0.0,
                max: totalDuration.inMilliseconds.toDouble(),
                activeColor: Colors.white70,
                onChanged: (double value) {
                  final position = Duration(milliseconds: value.toInt());
                  audioPlayerProvider.audioPlayer.seek(position);
                },
              ),
              Padding(
                  padding: const EdgeInsets.only(bottom: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.play_arrow),
                      color: Colors.white70,
                      onPressed: () {
                        audioPlayerProvider.playMusic(songPath);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.pause),
                      color: Colors.white70,
                      onPressed: () {
                        audioPlayerProvider.pauseMusic();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.stop),
                      color: Colors.white70,
                      onPressed: () {
                        audioPlayerProvider.stopMusic();
                      },
                    ),
                  ],
                ),
              ),

            ],
          );
        },
      ),
    ),
    );
  }
}
