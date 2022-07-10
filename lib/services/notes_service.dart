import 'dart:convert';

import 'package:working_with_rest_api/models/api_response.dart';
import 'package:working_with_rest_api/models/note_for_listing.dart';
import 'package:http/http.dart' as http;

import '../models/note.dart';

class NotesService {
  static const API = 'https://tq-notes-api-jkrgrdggbq-el.a.run.app/';
  static const headers = {'apiKey': '513101a3-f322-4751-966c-47616711ecb7'};

  Future<APIResponse<List<NoteForListing>>> getNoteList() {
    return http.get(Uri.parse(API + '/notes'), headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final notes = <NoteForListing>[];

        for (var item in jsonData) {
          final note = NoteForListing(
            noteID: item['noteID'],
            noteTitle: item['noteTitle'],
            createDateTime: DateTime.parse(item['createDateTime']),
            latestEditDateTime: item['latestEditDateTime'] != null
                ? DateTime.parse(item['latestEditDateTime'])
                : null,
          );
          notes.add(note);
        }
        return APIResponse<List<NoteForListing>>(data: notes);
      }
      return APIResponse<List<NoteForListing>>(
          error: true, errorMessage: 'An error occured');
    }).catchError((_) => APIResponse<List<NoteForListing>>(
        error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<Note>> getNote(String noteID) {
    return http
        .get(Uri.parse(API + '/notes/' + noteID), headers: headers)
        .then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final note = Note(
          noteID: jsonData['noteID'],
          noteTitle: jsonData['noteTitle'],
          noteContent: jsonData['noteContent'],
          createDateTime: DateTime.parse(jsonData['createDateTime']),
          latestEditDateTime: jsonData['latestEditDateTime'] != null
              ? DateTime.parse(jsonData['latestEditDateTime'])
              : null,
        );

        return APIResponse<Note>(data: note);
      }
      return APIResponse<Note>(error: true, errorMessage: 'An error occured');
    }).catchError((_) =>
            APIResponse<Note>(error: true, errorMessage: 'An error occured'));
  }
}
