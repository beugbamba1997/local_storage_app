import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_storage_app/data/moor_db.dart';
import 'package:local_storage_app/data/shar_prefs.dart';
import 'package:local_storage_app/screen/post_detail.dart';
import 'package:provider/provider.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  int settingColor = 0xff1976d2;
  double fontSize = 16;
  ShardPrefs shardPrefs = ShardPrefs();
  List<BlogPost> posts = [];
  @override
  void initState() {
    shardPrefs = ShardPrefs();
    shardPrefs.init().then((_) {
      setState(() {
        settingColor = shardPrefs.getColor();
        fontSize = shardPrefs.getFontSize();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BlogDb blogDb = Provider.of<BlogDb>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Posts'),
        backgroundColor: Color(settingColor),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          BlogPost post = BlogPost(id: 0, name: '', content: '', date: null);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PostDetailscreen(post, true)));
        },
        backgroundColor: Color(settingColor),
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: blogDb.getPosts(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            posts = snapshot.data as List<BlogPost>;
          } else {
            posts = [];
          }
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: ((context, index) {
              DateFormat formatdate = DateFormat('dd/MM/yyyy');
              String postDate = (posts[index].date != null)
                  ? formatdate.format(posts[index].date!)
                  : '';
              return Dismissible(
                  key: Key(posts[index].id.toString()),
                  onDismissed: (direction) {
                    blogDb.deletePost(posts[index]);
                  },
                  child: ListTile(
                    title: Text(posts[index].name),
                    subtitle: Text(postDate),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PostDetailscreen(posts[index], false)));
                    },
                  ));
            }),
          );
        }),
      ),
    );
  }
}
