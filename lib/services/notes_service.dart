import 'package:working_with_rest_api/models/note_for_listing.dart';

class NotesService {
  List<NoteForListing> getNoteList() {
    return [
      NoteForListing(
          noteID: "1",
          createDateTime: DateTime.now(),
          latestEditDateTime: DateTime.now(),
          noteTitle: "Note 1"),
      NoteForListing(
          noteID: "2",
          createDateTime: DateTime.now(),
          latestEditDateTime: DateTime.now(),
          noteTitle: "Note 2"),
      NoteForListing(
          noteID: "3",
          createDateTime: DateTime.now(),
          latestEditDateTime: DateTime.now(),
          noteTitle: "Note 3"),
    ];
  }
}
