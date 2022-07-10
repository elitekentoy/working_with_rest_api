import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:working_with_rest_api/models/note_insert.dart';
import 'package:working_with_rest_api/services/notes_service.dart';

import '../models/note.dart';

class NoteModify extends StatefulWidget {
  const NoteModify({Key? key, this.noteID}) : super(key: key);

  final String? noteID;

  @override
  State<NoteModify> createState() => _NoteModifyState();
}

class _NoteModifyState extends State<NoteModify> {
  bool get isEditing => widget.noteID != null;

  NotesService get notesService => GetIt.I<NotesService>();

  String? errorMessage;
  Note? note;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  bool _isloading = false;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      setState(() {
        _isloading = true;
      });

      notesService.getNote(widget.noteID.toString()).then(
        (response) {
          setState(() {
            _isloading = false;
          });

          if (response.error == true) {
            errorMessage = response.errorMessage ?? 'An error occured';
          }

          note = response.data;
          _titleController.text = note!.noteTitle.toString();
          _contentController.text = note!.noteContent.toString();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit note' : 'Create note')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _isloading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: <Widget>[
                  TextField(
                    decoration: const InputDecoration(hintText: 'Note title'),
                    controller: _titleController,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    decoration: const InputDecoration(hintText: 'Note content'),
                    controller: _contentController,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 35,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (isEditing) {
                          //update Note
                        } else {
                          setState(() {
                            _isloading = true;
                          });

                          final note = NoteInsert(
                            noteTitle: _titleController.text,
                            noteContent: _contentController.text,
                          );
                          final result = await notesService.createNote(note);

                          setState(() {
                            _isloading = false;
                          });

                          final title = 'Done';
                          final text = result.error! ? (result.errorMessage ?? 'An error occured') : 'Your note was created.' ;

                          showDialog(
                            context: context,
                             builder: (_) => AlertDialog(
                              title: Text(title),
                              content: Text(text),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Ok'))
                              ],
                             ));

                        }
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
