import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:working_with_rest_api/models/note_for_listing.dart';
import 'package:working_with_rest_api/services/notes_service.dart';
import 'package:working_with_rest_api/views/note_delete.dart';
import 'package:working_with_rest_api/views/note_modify.dart';

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

  NotesService get service => GetIt.I<NotesService>();

  String formatDateTime(DateTime? dateTime){
    return '${dateTime!.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List of Notes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NoteModify()));
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.separated(
        separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.green),
        itemBuilder: (_, index) {
          return Dismissible(
            key: ValueKey(notes[index].noteID),
            direction: DismissDirection.startToEnd,
            onDismissed: (direction) {

            },
            confirmDismiss: (direction) async {
              final result = await showDialog(
                context: context,
                builder: (_) => const NoteDelete()
              );
              return result;
            },
            background: Container(
              color: Colors.red,
              padding: const EdgeInsets.only(left: 16),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Icon(Icons.delete, color: Colors.white,),
              ),
            ),
            child: ListTile(
              title: Text(
                notes[index].noteTitle.toString(),
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              subtitle: Text('Last edited on ${formatDateTime(notes[index].latestEditDateTime)}'),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => NoteModify(noteID: notes[index].noteID,)));
              },
            ),
          );
        },
        itemCount: notes.length,
      ),
    );
  }
}
