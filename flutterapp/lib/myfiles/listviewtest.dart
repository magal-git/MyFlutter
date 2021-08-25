import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/myfiles/mycard.dart';


class MyApp extends StatelessWidget {
  List<String> items = [];


  @override
  Widget build(BuildContext context) {
    const title = 'Long List';
    items = List<String>.generate(10, (i) => 'Item $i');

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return
            ListTile(
              title: MyCard(),
            );
          },
        ),
      ),
    );
  }
}