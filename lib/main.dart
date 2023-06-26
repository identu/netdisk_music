import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netdisk_music/pages/home_music.dart';
import 'package:netdisk_music/pages/main_screen.dart';
import 'package:netdisk_music/pages/music_list.dart';
import 'package:netdisk_music/pages/netdisk_music_page.dart';
import 'package:netdisk_music/pages/playlist_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Web Music Player',
      theme: ThemeData(
          textTheme: Theme.of(context).textTheme.apply(
            bodyColor: Color.fromRGBO(0, 117, 102, 1),
            displayColor: Color.fromRGBO(0, 117, 102, 1),
          )
      ),
      home: MainScreen(),
      getPages: [
        GetPage(name: '/', page: () => const HomeMusic()),
        GetPage(name: '/song', page: () => const MusicList()),
        GetPage(name: '/playlist', page: () => const PlaylistPage()),
        GetPage(name: '/netdisk-music', page: () => const NetdiskMusicPage(),
        ),
        // GetPage(name: '/favourite', page: () => const FavouritePage()),
        // GetPage(name: '/profile', page: () => const ProfilePage()),
      ],
    );
  }
}
