import 'dart:io';
import 'package:local_storage_app/screen/files.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:local_storage_app/data/file_helper.dart';
import 'package:local_storage_app/data/shar_prefs.dart';
import 'package:share/share.dart';

class FileScreen extends StatefulWidget {
  final File? file;
  const FileScreen(this.file, {super.key});

  @override
  State<FileScreen> createState() => _FileScreenState();
}

class _FileScreenState extends State<FileScreen> {
  int settingcolor = 0xff1976d2;
  double fontSize = 16;
  ShardPrefs shardPrefs = ShardPrefs();
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController contentcontroller = TextEditingController();
  FileHelper helper = FileHelper();

  @override
  void initState() {
    shardPrefs = ShardPrefs();
    shardPrefs.init().then((_) {
      setState(() {
        settingcolor = shardPrefs.getColor();
        fontSize = shardPrefs.getFontSize();
      });
    });
    helper = FileHelper();
    if (widget.file == null) {
      titlecontroller.text = 'new file';
      contentcontroller.text = '';
    } else {
      titlecontroller.text = basename(widget.file!.path);
      helper
          .readFromFile(widget.file!)
          .then((value) => contentcontroller.text = value);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: titlecontroller,
          style: TextStyle(fontSize: fontSize, color: Colors.white),
        ),
        backgroundColor: Color(settingcolor),
        actions: [
          IconButton(
              onPressed: (() {
                saveFile().then((value) => Share.shareFiles([widget.file!.path],
                    text: basename(widget.file!.path)));
              }),
              icon: const Icon(Icons.share)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
                child: TextField(
              maxLines: null,
              expands: true,
              controller: contentcontroller,
              style: TextStyle(fontSize: fontSize),
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          saveFile();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: ((context) => const FilesScreen())));
        },
        backgroundColor: Color(settingcolor),
        child: const Icon(Icons.save),
      ),
    );
  }

  Future saveFile() async {
    helper.writeToFile(titlecontroller.text, contentcontroller.text);
  }
}
