import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomeMusic extends StatefulWidget {
  const HomeMusic({Key? key}) : super(key: key);

  @override
  _HomeMusicState createState() => _HomeMusicState();
}

class _HomeMusicState extends State<HomeMusic> {
  final OnAudioQuery audioQuery = OnAudioQuery();

  // List<SongModel> songs = [];
  // List<AlbumModel> albums = [];

  @override
  void initState() {
    super.initState();
    _loadLocalMusicAlbums();
  }

  Future<void> _loadLocalMusicAlbums() async {
    audioQuery.querySongs();
    // await audioQuery.scanMedia('./local_music');
    // songs = await audioQuery.querySongs(path: './local_music');
    // albums = await audioQuery.queryAlbums();
    setState(() {});
  }

  Future<Uint8List?> _getAlbumArt(String albumId) async {
    final artwork = await audioQuery.queryArtwork(albumId as int,ArtworkType.ARTIST);
    return artwork;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Player'),
      ),
      body: ListView.builder(
        // itemCount: albums.length,
        itemBuilder: (context, index) {
          // final album = albums[index];
          return ListTile(
            leading: FutureBuilder<Uint8List?>(
              // future: _getAlbumArt(album.id as String),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Image.memory(snapshot.data!, width: 50, height: 50);
                } else {
                  return const SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(Icons.music_note),
                  );
                }
              },
            ),
            // title: Text(album.album),
            // subtitle: Text(album.artist ?? ''),
          );
        },
      ),
    );
  }
}
