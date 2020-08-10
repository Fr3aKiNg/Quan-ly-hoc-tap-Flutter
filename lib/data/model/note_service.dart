import 'package:flutter/material.dart';
import 'package:scheduleapp/data/model/note.dart';

abstract class NoteCommand {
  final String id;
  final String uid;

  /// Whether this command should dismiss the current screen.
  final bool dismiss;

  /// Defines an undoable action to a note, provides the note [id], and current user [uid].
  const NoteCommand({
    @required this.id,
    @required this.uid,
    this.dismiss = false,
  });

  /// Returns `true` if this command is undoable.
  bool get isUndoable => true;

  /// Returns message about the result of the action.
  String get message => '';

  /// Executes this command.
  Future<void> execute();

  /// Undo this command.
  Future<void> revert();
}

/// A [NoteCommand] to update state of a [Note].
class NoteStateUpdateCommand extends NoteCommand {
  final NoteState from;
  final NoteState to;

  /// Create a [NoteCommand] to update state of a note [from] the current state [to] another.
  NoteStateUpdateCommand({
    @required String id,
    @required String uid,
    @required this.from,
    @required this.to,
    bool dismiss = false,
  }) : super(id: id, uid: uid, dismiss: dismiss);

  @override
  String get message {
    switch (to) {
      case NoteState.deleted:
        return 'Xóa ghi chú';
//      case NoteState.archived:
//        return 'Lưu trữ ghi chú';
      case NoteState.pinned:
        return
//          from == NoteState.archived
//            ? 'Note pinned and unarchived' // pin an archived note
//            :
          '';
      default:
        switch (from) {
//          case NoteState.archived:
//            return 'Note unarchived';
          case NoteState.deleted:
            return 'Note restored';
          default:
            return '';
        }
    }
  }

  @override
  Future<void> execute() => updateNoteState(to, id, uid);

  @override
  Future<void> revert() => updateNoteState(from, id, uid);
}

/// Mixin helps handle a [NoteCommand].
mixin CommandHandler<T extends StatefulWidget> on State<T> {
  /// Processes the given [command].
  Future<void> processNoteCommand(ScaffoldState scaffoldState, NoteCommand command) async {
    if (command == null) {
      return;
    }
    await command.execute();
    final msg = command.message;
    if (mounted && msg?.isNotEmpty == true && command.isUndoable) {
      scaffoldState?.showSnackBar(SnackBar(
        content: Text(msg),
        action: SnackBarAction(
          label: 'Hoàn tác',
          onPressed: () => command.revert(),
        ),
      ));
    }
  }
}