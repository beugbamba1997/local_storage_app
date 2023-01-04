import 'dart:io';
import 'package:local_storage_app/screen/files_content.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:local_storage_app/data/file_helper.dart';
import 'package:local_storage_app/data/shar_prefs.dart';

class FilesScreen extends StatefulWidget {
  const FilesScreen({super.key});

  @override
  State<FilesScreen> createState() => _FilesScreenState();
}

class _FilesScreenState extends State<FilesScreen> {
  int settingcolor = 0xff1976d2;
  double fontSize = 16;
  ShardPrefs shardPrefs = ShardPrefs();
  FileHelper helper = FileHelper();
  List<File> files = [];

  @override
  void initState() {
    shardPrefs = ShardPrefs();
    shardPrefs.init().then((_) {
      setState(() {
        settingcolor = shardPrefs.getColor();
        fontSize = shardPrefs.getFontSize();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File'),
        backgroundColor: Color(settingcolor),
      ),
      body: FutureBuilder(
        future: helper.getFiles(),
        builder: ((context, snapshot) {
          files = (snapshot.data == null) ? [] : snapshot.data as List<File>;
          return ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(basename(files[index].path)),
                onDismissed: (direction) {
                  helper.deleteFile(files[index]);
                },
                child: ListTile(
                  title: Text(basename(files[index].path)),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FileScreen(files[index])));
                  },
                ),
              );
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const FileScreen(null)));
        },
        backgroundColor: Color(settingcolor),
        child: const Icon(Icons.add),
      ),
    );
  }
}
