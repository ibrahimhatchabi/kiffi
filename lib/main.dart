import 'package:flutter/material.dart';
import 'package:kiffi/teaser.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:kiffi/librairies/globals.dart' as globals;
import 'package:contacts_service/contacts_service.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kiffi',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new TeaserPage(),
    );
  }
}




