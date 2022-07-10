import 'package:flutter/material.dart';
import 'package:working_with_rest_api/models/note_for_listing.dart';

class NoteList extends StatelessWidget {
  NoteList({Key? key}) : super(key: key);

  final notes = [
    NoteForListing(
      noteID: "1",
      createDateTime: DateTime.now(),
      latestEditDateTime: DateTime.now(),
      noteTitle: "Note 1"
    ),
    NoteForListing(
      noteID: "2",
      createDateTime: DateTime.now(),
      latestEditDateTime: DateTime.now(),
      noteTitle: "Note 2"
    ),
    NoteForListing(
      noteID: "3",
      createDateTime: DateTime.now(),
      latestEditDateTime: DateTime.now(),
      noteTitle: "Note 3"
    ),
  ];

  String formatDateTime(DateTime? dateTime){
    return '${dateTime!.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List of Notes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: ListView.separated(
        separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.green),
        itemBuilder: (_, index) {
          return ListTile(
            title: Text(
              notes[index].noteTitle.toString(),
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            subtitle: Text('Last edited on ${formatDateTime(notes[index].latestEditDateTime)}'),
          );
        },
        itemCount: notes.length,
      ),
    );
  }
}