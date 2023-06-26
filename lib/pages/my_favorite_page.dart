import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'song_selection.dart';

class MyFavoritePage extends StatefulWidget {
  final String playlist;

  MyFavoritePage({required this.playlist});

  @override
  _MyFavoritePageState createState() => _MyFavoritePageState();
}

class _MyFavoritePageState extends State<MyFavoritePage> {
  List<String> allSongs = [
    '11',
    '22',
  ];

  List<String> favoriteSongs = [];

  late SharedPreferences _preferences;

  @override
  void initState() {
    super.initState();
    loadFavoriteSongs();
  }

  Future<void> loadFavoriteSongs() async {
    _preferences = await SharedPreferences.getInstance();
    setState(() {
      favoriteSongs = _preferences.getStringList('favoriteSongs') ?? [];
    });
  }

  Future<void> saveFavoriteSongs() async {
    await _preferences.setStringList('favoriteSongs', favoriteSongs);
  }

  void addSong(String song) {
    setState(() {
      favoriteSongs.add(song);
      saveFavoriteSongs();
    });
  }

  void removeSong(String song) {
    setState(() {
      favoriteSongs.remove(song);
      saveFavoriteSongs();
    });
  }

  bool isSongFavorite(String song) {
    return favoriteSongs.contains(song);
  }

  @override
  Widget build(BuildContext context) {
    List<String> songsFromLocal = [
      '11',
      '22',
      '33',
    ];

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
          title: Text(widget.playlist),

          actions: [
            ElevatedButton(
              onPressed: () async {
                final selectedSongs = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SongSelectionPage(
                      allSongs: songsFromLocal,
                      favoriteSongs: favoriteSongs,
                      onAddSong: addSong,
                    ),
                  ),
                );

                if (selectedSongs != null) {
                  setState(() {
                    favoriteSongs.clear();
                    favoriteSongs.addAll(selectedSongs);
                    saveFavoriteSongs();
                  });
                }
              },
              style: OutlinedButton.styleFrom(
                primary: Colors.white70,
                backgroundColor: Colors.black12,
              ),
              child: Text('添加歌曲'),
            ),
          ],
          backgroundColor: Colors.transparent,
          // Set app bar background color to transparent
          elevation: 0, // Remove app bar elevation
        ),
        backgroundColor: Colors.transparent,
        body:Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: favoriteSongs.length,
                  itemBuilder: (context, index) {
                    final song = favoriteSongs[index];
                    final isFavorite = isSongFavorite(song);

                    return ListTile(
                      title: Text(song),
                      textColor: Colors.white70,
                      trailing: IconButton(
                        onPressed: () {
                          removeSong(song);
                        },
                        icon: Icon(Icons.delete),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

    );
  }
}
