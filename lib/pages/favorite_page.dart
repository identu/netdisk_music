import 'package:flutter/material.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({Key? key}) : super(key: key);

  @override
  _FavouritePageState createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  List<String> songs = [
    'Song 1',
    'Song 2',
    'Song 3',
    'Song 4',
    'Song 5',
  ];

  String selectedSong = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourite List'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                final isSelected = song == selectedSong;

                return ListTile(
                  title: Text(song),
                  selected: isSelected,
                  onTap: () {
                    setState(() {
                      selectedSong = song;
                    });
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle play button action
              if (selectedSong.isNotEmpty) {
                // Play the selected song
                print('Playing $selectedSong');
              }
            },
            child: const Text('Play'),
          ),
        ],
      ),
    );
  }
}
