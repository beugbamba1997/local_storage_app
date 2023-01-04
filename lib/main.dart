import 'package:flutter/material.dart';
import 'package:local_storage_app/data/moor_db.dart';
import 'package:local_storage_app/screen/home.dart';
import 'package:local_storage_app/screen/setting.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return Provider(
      create: (context) => BlogDb(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
