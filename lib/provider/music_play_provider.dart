import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

enum AudioPlayerState {
  STOPPED,
  PLAYING,
  PAUSED,
}

class AudioPlayerProvider extends ChangeNotifier {
  late AudioPlayer audioPlayer;
  AudioPlayerState audioPlayerState = AudioPlayerState.STOPPED;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;

  AudioPlayerProvider() {
    audioPlayer = AudioPlayer();
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.stopped) {
        audioPlayerState = AudioPlayerState.STOPPED;
      } else if (state == PlayerState.playing) {
        audioPlayerState = AudioPlayerState.PLAYING;
      } else if (state == PlayerState.paused) {
        audioPlayerState = AudioPlayerState.PAUSED;
      }
      notifyListeners();
    });
    audioPlayer.onPositionChanged.listen((Duration position) {
      currentPosition = position;
      notifyListeners();
    });
    audioPlayer.onDurationChanged.listen((Duration duration) {
      totalDuration = duration;
      notifyListeners();
    });

  }

  get currentSong => null;

  Future<void> playMusic(String songPath) async {
    await audioPlayer.play(AssetSource(songPath));
    notifyListeners();
  }

  Future<void> pauseMusic() async {
    await audioPlayer.pause();
    notifyListeners();
  }

  Future<void> stopMusic() async {
    await audioPlayer.stop();
    notifyListeners();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  void seek(Duration duration) {}
}
