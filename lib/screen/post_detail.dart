import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_storage_app/data/moor_db.dart';
import 'package:local_storage_app/data/shar_prefs.dart';
import 'package:local_storage_app/screen/posts.dart';
import 'package:moor_flutter/moor_flutter.dart' hide Column;

import 'package:provider/provider.dart';

class PostDetailscreen extends StatefulWidget {
  final BlogPost post;
  final isNew;
  const PostDetailscreen(this.post, this.isNew, {super.key});

  @override
  State<PostDetailscreen> createState() => _PostDetailscreenState();
}

class _PostDetailscreenState extends State<PostDetailscreen> {
  int settingcolor = 0xff1976d2;
  double fonSize = 16;
  ShardPrefs shardPrefs = ShardPrefs();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtContent = TextEditingController();
  TextEditingController txtDate = TextEditingController();
  DateFormat formatter = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    shardPrefs = ShardPrefs();
    shardPrefs.init().then((_) {
      setState(() {
        settingcolor = shardPrefs.getColor();
        fonSize = shardPrefs.getFontSize();
      });
    });
    txtName.text = widget.post.name;
    txtContent.text = widget.post.content ?? '';
    String postDate =
        (widget.post.date != null) ? formatter.format(widget.post.date!) : '';

    txtDate.text = postDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BlogDb blogDb = Provider.of<BlogDb>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Blog View'),
          backgroundColor: Color(settingcolor),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            BlogText(
                description: 'Name',
                controller: txtName,
                textSize: fonSize,
                numLines: 1),
            BlogText(
                description: 'content',
                controller: txtContent,
                textSize: fonSize,
                numLines: 5),
            BlogText(
                description: 'Date',
                controller: txtDate,
                textSize: fonSize,
                numLines: 1),
          ],
        )),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(settingcolor),
          onPressed: () {
            BlogPost updated = BlogPost(
              id: (widget.isNew) ? 0 : widget.post.id,
              name: txtName.text,
              content: txtContent.text,
              date: (txtDate.text != '') ? formatter.parse(txtDate.text) : null,
            );
            if (widget.isNew) {
              BlogPostsCompanion newPost = BlogPostsCompanion(
                name: Value(txtName.text),
                content: Value(txtContent.text),
                date: (txtDate.text != '')
                    ? Value(formatter.parse(txtDate.text))
                    : Value(null),
              );
              blogDb.insertPost(newPost);
            } else {
              blogDb.updatePost(updated);
            }
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => PostsScreen()));
          },
          child: const Icon(Icons.save),
        ));
  }
}

class BlogText extends StatelessWidget {
  final String description;
  final TextEditingController controller;
  final double textSize;
  final int numLines;
  const BlogText(
      {super.key,
      required this.description,
      required this.controller,
      required this.textSize,
      required this.numLines});

  @override
  Widget build(BuildContext context) {
    TextInputType textInputType;
    if (numLines > 1) {
      textInputType = TextInputType.multiline;
    } else if (description == 'Date') {
      textInputType = TextInputType.datetime;
    } else {
      textInputType = TextInputType.text;
    }
    return Padding(
        padding: const EdgeInsets.all(24.0),
        child: TextField(
          controller: controller,
          keyboardType: textInputType,
          maxLines: numLines,
          style: TextStyle(fontSize: textSize),
          decoration: InputDecoration(
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              hintText: description),
        ));
  }
}
