import 'package:flutter/material.dart';

import 'views/note_list.dart';

void main () => runApp(const App());

class  App extends StatelessWidget {
  const  App({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: const NoteList(),
    );
  }
}
