import 'dart:io';
import 'package:flutter/material.dart';
import 'my_favorite_page.dart';

class SongSelectionPage extends StatefulWidget {
  final List<String> allSongs;
  final List<String> favoriteSongs;
  final Function(String) onAddSong;

  SongSelectionPage({
    required this.allSongs,
    required this.favoriteSongs,
    required this.onAddSong,
  });

  @override
  _SongSelectionPageState createState() => _SongSelectionPageState();
}

class _SongSelectionPageState extends State<SongSelectionPage> {
  List<String> songsFromLocal = [];

  @override
  void initState() {
    super.initState();
    loadSongsFromLocal();
  }

  void loadSongsFromLocal() async {
    try {
      final directory = Directory('assets/local_music');
      final files = directory.listSync();

      List<String> localSongs = [];
      for (var file in files) {
        if (file is File) {
          localSongs.add(file.path.split('/').last);
        }
      }

      setState(() {
        songsFromLocal = localSongs;
      });
    } catch (e) {
      print('Error loading songs from local directory: $e');
    }
  }

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
    child:Scaffold(

      appBar: AppBar(
        title: const Text('本地音乐'),
        backgroundColor: Colors.transparent,
        // Set app bar background color to transparent
        elevation: 0, // Remove app bar elevation
      ),
      backgroundColor: Colors.transparent,
      // Set scaffold background color to transparent

      body:
       ListView.builder(
          itemCount: songsFromLocal.length,
          itemBuilder: (context, index) {
            final song = songsFromLocal[index];
            final isFavorite = widget.favoriteSongs.contains(song);

            return ListTile(
              title: Text(
                song,
                style: TextStyle(color: Colors.white),
              ),
              trailing: IconButton(
                onPressed: () {
                  if (!isFavorite) {
                    widget.onAddSong(song);
                  }
                },
                icon: Icon(
                  isFavorite ? Icons.check : Icons.add,
                  color: isFavorite ? Colors.blue : null,
                ),
              ),
            );
          },
        ),
      ),

    );
  }
}