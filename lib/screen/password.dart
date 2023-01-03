import 'package:flutter/material.dart';
import 'package:local_storage_app/data/sembast_db.dart';
import 'package:local_storage_app/data/shar_prefs.dart';
import 'package:local_storage_app/model/password.dart';
import 'package:local_storage_app/screen/password_detail.dart';

class PasswordScreens extends StatefulWidget {
  const PasswordScreens({super.key});

  @override
  State<PasswordScreens> createState() => _PasswordScreensState();
}

class _PasswordScreensState extends State<PasswordScreens> {
  late SembastDB db;
  int settingColor = 0xff1976d2;
  double fontSize = 16;
  ShardPrefs shardPrefs = ShardPrefs();
  @override
  void initState() {
    db = SembastDB();

    shardPrefs = ShardPrefs();
    shardPrefs.init().then((value) {
      setState(() {
        settingColor = shardPrefs.getColor();
        fontSize = shardPrefs.getFontSize();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password list'),
        backgroundColor: Color(settingColor),
      ),
      body: FutureBuilder(
          future: getPasswords(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            List<Password> passwords = snapshot.data ?? [];
            return ListView.builder(
              itemCount: passwords == [] ? 0 : passwords.length,
              itemBuilder: (_, index) {
                return Dismissible(
                  key: Key(passwords[index].id.toString()),
                  child: ListTile(
                    title: Text(
                      passwords[index].name,
                      style: TextStyle(fontSize: fontSize),
                    ),
                    trailing: const Icon(Icons.edit),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return PasswordDetailDialog(
                                password: passwords[index], isNew: false);
                          });
                    },
                  ),
                  onDismissed: (_) {
                    db.deletePassword(passwords[index]);
                  },
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(settingColor),
        onPressed: (() {
          showDialog(
              context: context,
              builder: (context) {
                return PasswordDetailDialog(
                    password: Password('', ''), isNew: true);
              });
        }),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<List<Password>> getPasswords() async {
    List<Password> passwords = await db.getPasswords();
    return passwords;
  }
}
