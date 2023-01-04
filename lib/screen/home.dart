import 'package:flutter/material.dart';
import 'package:local_storage_app/data/shar_prefs.dart';
import 'package:local_storage_app/screen/files.dart';
import 'package:local_storage_app/screen/notes.dart';
import 'package:local_storage_app/screen/password.dart';
import 'package:local_storage_app/screen/posts.dart';
import 'package:local_storage_app/screen/setting.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int settingColor = 0xff19676d2;
  double fontSize = 16;
  late ShardPrefs shardPrefs;

  @override
  void initState() {
    shardPrefs = ShardPrefs();
    getSharPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSharPrefs(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('My APP'),
            backgroundColor: Color(settingColor),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color(settingColor),
                  ),
                  child: const Text(
                    'App Menu',
                    style: TextStyle(color: Colors.white, fontSize: 28),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Settings',
                    style: TextStyle(fontSize: fontSize),
                  ),
                  onTap: (() {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Settings()));
                  }),
                ),
                ListTile(
                  title: Text(
                    'Passwords',
                    style: TextStyle(fontSize: fontSize),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PasswordScreens()));
                  },
                ),
                ListTile(
                  title: Text(
                    'Notes',
                    style: TextStyle(fontSize: fontSize),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NotesScreen()));
                  },
                ),
                ListTile(
                  title: Text(
                    'Posts',
                    style: TextStyle(fontSize: fontSize),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PostsScreen()));
                  },
                ),
                ListTile(
                  title: Text(
                    'Files',
                    style: TextStyle(fontSize: fontSize),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FilesScreen()));
                  },
                ),
              ],
            ),
          ),
          body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/travel.jpg'), fit: BoxFit.cover)),
          ),
        );
      },
    );
  }

  Future getSharPrefs() async {
    shardPrefs = ShardPrefs();
    shardPrefs.init().then((value) {
      setState(() {
        settingColor = shardPrefs.getColor();
        fontSize = shardPrefs.getFontSize();
      });
    });
  }
}
