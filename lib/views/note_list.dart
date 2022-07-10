import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:working_with_rest_api/models/api_response.dart';
import 'package:working_with_rest_api/models/note_for_listing.dart';
import 'package:working_with_rest_api/services/notes_service.dart';
import 'package:working_with_rest_api/views/note_delete.dart';
import 'package:working_with_rest_api/views/note_modify.dart';

class NoteList extends StatefulWidget {
  NoteList({Key? key}) : super(key: key);

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  NotesService get service => GetIt.I<NotesService>();

  bool _isloading = false;
  late APIResponse<List<NoteForListing>> _apiResponse;

  String formatDateTime(DateTime? dateTime) {
    return '${dateTime!.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  void initState() {
    _fetchNotes();
    super.initState();
  }

  _fetchNotes() async {
    setState(() {
      _isloading = true;
    });

    _apiResponse = await service.getNoteList();

    setState(() {
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List of Notes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const NoteModify()));
        },
        child: const Icon(Icons.add),
      ),
      body: Builder(
        builder: (_) {
          if (_isloading) {
            return const CircularProgressIndicator();
          }

          //SHADY
          if (_apiResponse.error == true) {
            return Center(child: Text(_apiResponse.errorMessage.toString()));
          }

          return ListView.separated(
            separatorBuilder: (_, __) =>
                const Divider(height: 1, color: Colors.green),
            itemBuilder: (_, index) {
              return Dismissible(
                key: ValueKey(_apiResponse.data![index].noteID),
                direction: DismissDirection.startToEnd,
                onDismissed: (direction) {},
                confirmDismiss: (direction) async {
                  final result = await showDialog(
                      context: context, builder: (_) => const NoteDelete());
                  return result;
                },
                background: Container(
                  color: Colors.red,
                  padding: const EdgeInsets.only(left: 16),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
                child: ListTile(
                  title: Text(
                    _apiResponse.data![index].noteTitle.toString(),
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  subtitle: Text(
                      'Last edited on ${formatDateTime(_apiResponse.data![index].latestEditDateTime ?? _apiResponse.data![index].createDateTime)}'),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => NoteModify(
                              noteID: _apiResponse.data![index].noteID,
                            )));
                  },
                ),
              );
            },
            itemCount: _apiResponse.data!.length,
          );
        },
      ),
    );
  }
}
