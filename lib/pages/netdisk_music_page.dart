import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NetdiskMusicPage extends StatefulWidget {
  const NetdiskMusicPage({Key? key}) : super(key: key);

  @override
  _NetdiskMusicPageState createState() => _NetdiskMusicPageState();
}

class _NetdiskMusicPageState extends State<NetdiskMusicPage> {
  List<String> musicList = [];
  Set<String> downloadedSongs = {}; // 保存已下载的音乐名字
  bool isLoading = false;
  String downloadingSong = ''; // 当前正在下载的音乐文件名

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
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Netdisk Music'),
        actions: [
          IconButton(
            onPressed: downloadAllMusic, // 点击全部下载按钮时调用 downloadAllMusic 方法下载所有音乐
            icon: const Icon(Icons.cloud_download),
          ),
        ],
      ),
      body: Center(
        child: isLoading
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(), // 显示加载指示器
            const SizedBox(height: 16),
            Text('Downloading: $downloadingSong'), // 显示当前正在下载的文件名
          ],
        )
            : musicList.isEmpty
            ? ElevatedButton(
          onPressed: fetchMusicList, // 点击按钮时调用 fetchMusicList 方法获取音乐列表
          child: const Text('Fetch Music List'),
        )
            : ListView.separated(
          itemCount: musicList.length,
          separatorBuilder: (context, index) => const Divider(), // 添加分隔线
          itemBuilder: (context, index) {
            final musicName = musicList[index];
            final isDownloaded = downloadedSongs.contains(musicName); // 检查音乐是否已下载

            return ListTile(
              title: Text(musicName,
                  style: const TextStyle(color: Colors.white70),),

              trailing: IconButton(
                onPressed: isDownloaded
                    ? null // 如果已下载，按钮不可点击
                    : () {
                  downloadMusic(musicName); // 下载音乐
                },
                icon: Icon(
                  Icons.download,
                  color: isDownloaded ? Colors.green : null, // 已下载的音乐按钮颜色为绿色
                ),
              ),
            );
          },
        ),
      ),
    )

    );

  }

  Future<void> fetchMusicList() async {
    setState(() {
      isLoading = true; // 开始加载音乐列表，显示加载指示器
    });

    try {
      final response = await http.get(Uri.parse('http://localhost:8080/api/files/list'));
      if (response.statusCode == 200) {
        // 请求成功，解析响应数据并更新音乐列表
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        final List<String> fetchedMusicList = data.map((item) => item.toString()).toList();
        setState(() {
          musicList = fetchedMusicList;
        });
      } else {
        // 请求失败，打印错误信息
        print('Failed to fetch music list. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // 发生异常，打印错误信息
      print('Error: $error');
    } finally {
      setState(() {
        isLoading = false; // 加载完成，隐藏加载指示器
      });
    }
  }

  Future<void> downloadMusic(String musicName) async {
    setState(() {
      downloadingSong = musicName; // 更新当前正在下载的音乐文件名
    });

    try {
      final response = await http.get(Uri.parse('http://localhost:8080/api/files/$musicName'),
          headers: {'Accept': 'application/octet-stream'});

      if (response.statusCode == 200) {
        // 获取到音乐文件的字节流
        final musicBytes = response.bodyBytes;

        // 将音乐文件保存到本地
        final file = File('assets/local_music/$musicName');
        await file.writeAsBytes(musicBytes);

        // 更新已下载的音乐集合
        setState(() {
          downloadedSongs.add(musicName);
        });

        // TODO: 根据需要处理下载完成后的逻辑，例如弹出提示或进行其他操作
        print('Downloaded $musicName');
      } else {
        // 请求失败，打印错误信息
        print('Failed to download $musicName. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // 发生异常，打印错误信息
      print('Error: $error');
    } finally {
      setState(() {
        downloadingSong = ''; // 清空当前正在下载的音乐文件名
      });
    }
  }

  Future<void> downloadAllMusic() async {
    setState(() {
      isLoading = true; // 开始全部下载，显示加载指示器
    });

    for (final musicName in musicList) {
      if (!downloadedSongs.contains(musicName)) {
        await downloadMusic(musicName);
      }
    }

    setState(() {
      isLoading = false; // 全部下载完成，隐藏加载指示器
    });
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music App',
      theme: ThemeData(
        primarySwatch: Colors.green, // 设置主题颜色为绿色
      ),
      home: const NetdiskMusicPage(),
    );
  }
}
