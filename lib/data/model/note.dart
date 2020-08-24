import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:collection_ext/iterables.dart';
class Note extends ChangeNotifier{
  final String id;
  String title;
  String content;
  NoteState state;
  Color color;
  Note({this.id,this.title,this.content,this.state,this.color});

  static List<Note> fromQuery(QuerySnapshot snapshot) => snapshot != null ? snapshot.toNotes() : [];

  bool get isNotEmpty => title?.isNotEmpty == true || content?.isNotEmpty == true;

  int get stateValue => (state ?? NoteState.unspecified).index;



  bool get pinned => state == NoteState.pinned;
  void update(Note other, {bool updateTimestamp = true}) {
    title = other.title;
    content = other.content;
    color = other.color;
    state = other.state;
    notifyListeners();
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'state':stateValue,
    'color': color?.value
  };
  Note copy({bool updateTimestamp = false}) => Note(
    id: id,
  )..update(this, updateTimestamp: updateTimestamp);

  Note updateWith({
    String title,
    String content,
    Color color,
    NoteState state,
    bool updateTimestamp = true,
  }) {
    if (title != null) this.title = title;
    if (content != null) this.content = content;
    if (color != null) this.color = color;
    if (state != null) this.state = state;
    notifyListeners();
    return this;
  }
}
Color _parseColor(num colorInt) => Color(colorInt ?? 0xFFFFFFFF);
enum NoteState {
  unspecified,
  pinned,
  archived,
  deleted,
}
extension NoteQuery on QuerySnapshot {
  List<Note> toNotes() => documents
      .map((d) => d.toNote())
      .nonNull
      .asList();
}
extension NoteDocument on DocumentSnapshot {
  /// Transforms the query result into a list of notes.
  Note toNote() => exists
      ? Note(
    id: documentID,
    title: data['title'],
    content: data['content'],
    color: _parseColor(data['color']),
  )
      : null;

}
extension NoteStore on Note {

  Future<dynamic> saveToFireStore(String uid) async {
    final col = notesCollection(uid);
    return id == null
        ? col.add(toJson())
        : col.document(id).updateData(toJson());
  }
  /// Update this note to the given [state].
  Future<void> updateState(NoteState state, String uid) async => id == null
      ? updateWith(state: state) // new note
      : updateNoteState(state, id, uid);
}
CollectionReference notesCollection(String uid) => Firestore.instance.collection('notes-$uid');

/// Returns reference to the given note [id] of the user [uid].
DocumentReference noteDocument(String id, String uid) => notesCollection(uid).document(id);

/// Update a note to the [state], using information in the [command].
Future<void> updateNoteState(NoteState state, String id, String uid) =>
    updateNote({'state': state?.index ?? 0}, id, uid);

/// Update a note [id] of user [uid] with properties [data].
Future<void> updateNote(Map<String, dynamic> data, String id, String uid) =>
    noteDocument(id, uid).updateData(data);

extension NoteStateX on NoteState {
  /// Checks if it's allowed to create a new note in this state.
  bool get canCreate => this <= NoteState.pinned;

  /// Checks if a note in this state can edit (modify / copy).
  bool get canEdit => this < NoteState.deleted;

  bool operator <(NoteState other) => (this?.index ?? 0) < (other?.index ?? 0);
  bool operator <=(NoteState other) => (this?.index ?? 0) <= (other?.index ?? 0);

  /// Message describes the state transition.
  String get message {
    switch (this) {
      case NoteState.archived:
        return 'Lưu trữ';
      case NoteState.deleted:
        return 'Xóa ghi chú';
      default:
        return '';
    }
  }

  /// Label of the result-set filtered via this state.
  String get filterName {
    switch (this) {
      case NoteState.archived:
        return 'Archive';
      case NoteState.deleted:
        return 'Trash';
      default:
        return '';
    }
  }

  /// Short message explains an empty result-set filtered via this state.
  String get emptyResultMessage {
    switch (this) {
      case NoteState.archived:
        return 'Archived notes appear here';
      case NoteState.deleted:
        return 'Notes in trash appear here';
      default:
        return 'Notes you add appear here';
    }
  }
}
