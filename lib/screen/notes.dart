import 'package:flutter/material.dart';
import 'package:local_storage_app/data/shar_prefs.dart';
import 'package:local_storage_app/data/sql_helper.dart';
import 'package:local_storage_app/model/note.dart';
import 'package:local_storage_app/screen/note.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  int settingColor = 0xff1976D2;
  double fontSize = 16;
  ShardPrefs shardPrefs = ShardPrefs();
  SqlHelper sqlHelper = SqlHelper();

  @override
  void initState() {
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
        title: const Text('Notes'),
        backgroundColor: Color(settingColor),
      ),
      body: FutureBuilder(
        future: getNotes(),
        builder: (context, snapshot) {
          List<Note> notes =
              snapshot.data == null ? [] : snapshot.data as List<Note>;
          if (notes == null) {
            return Container();
          } else {
            return ReorderableListView(
                 onReorder: (oldIndex, newIndex) async {
                  final Note note = notes[oldIndex];
                  if (oldIndex > newIndex) {
                    await sqlHelper.updatePosition(true, oldIndex, newIndex);
                  } else if (oldIndex < newIndex) {
                    newIndex -= 1;
                    await sqlHelper.updatePosition(false, oldIndex, newIndex);
                  }
                  note.position = newIndex;
                  await sqlHelper.updateNote(note);
                  setState(() {
                    getNotes();
                  });
                },
                children: [
                  for (final note in notes)
                    Dismissible(
                        key: Key(note.id.toString()),
                        onDismissed: (direction) {
                          sqlHelper.deleteeNote(note);
                        },
                        child: Card(
                          key: ValueKey(note.position),
                          child: ListTile(
                            title: Text(note.name),
                           
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NoteScreen(note, false)));
                            },
                          ),
                        ))
                ]
               
      );
      }
        }),
      
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NoteScreen(Note('', '', '', 1), true)));
        }),
        backgroundColor: Color(settingColor),
        child: const Icon(Icons.add,),
      ),
    );
  }

  Future<List<Note>> getNotes() async {
    sqlHelper = SqlHelper();
    List<Note> notes = await sqlHelper.getNotes();
    return notes;
  }
}
