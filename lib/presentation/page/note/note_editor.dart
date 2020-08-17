import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scheduleapp/application/color_app.dart';
import 'package:scheduleapp/data/model/note.dart';
import 'package:scheduleapp/data/model/note_service.dart';
import 'package:scheduleapp/data/model/user.dart';
import 'package:scheduleapp/presentation/page/note/color_picker.dart';
import 'package:scheduleapp/presentation/page/note/note_actions.dart';


class NoteEditor extends StatefulWidget {
  const NoteEditor({Key key, this.note}) : super(key: key);

  final Note note;

  @override
  State<StatefulWidget> createState() => _NoteEditorState(note);
}

/// [State] of [NoteEditor].
class _NoteEditorState extends State<NoteEditor> with CommandHandler {

  _NoteEditorState(Note note)
      : this._note = note ?? Note(),
        _originNote = note?.copy() ?? Note(),
        this._titleTextController = TextEditingController(text: note?.title),
        this._contentTextController =
            TextEditingController(text: note?.content);

  final Note _note;


  final Note _originNote;
  Color get _noteColor => _note.color ?? ColorApp.White;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamSubscription<Note> _noteSubscription;
  final TextEditingController _titleTextController;
  final TextEditingController _contentTextController;


  bool get _isDirty => _note != _originNote;

  @override
  void initState() {
    super.initState();
    _titleTextController
        .addListener(() => _note.title = _titleTextController.text);
    _contentTextController
        .addListener(() => _note.content = _contentTextController.text);
  }

  @override
  void dispose() {
    _noteSubscription?.cancel();
    _titleTextController.dispose();
    _contentTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uid = Provider.of<CurrentUser>(context).data.uid;
    _watchNoteDocument(uid);
    return ChangeNotifierProvider.value(
      value: _note,
      child: Consumer<Note>(
        builder: (_, __, ___) => Hero(
          tag: 'NoteItem${_note.id}',
          child: Theme(
            data: Theme.of(context).copyWith(
              primaryColor: Colors.white,
              appBarTheme: Theme.of(context).appBarTheme.copyWith(
                    elevation: 0,
                  ),
              scaffoldBackgroundColor: _noteColor,
              bottomAppBarColor: ColorApp.backgroundColor,
            ),
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: Colors.white,
                systemNavigationBarColor: Colors.white,
                systemNavigationBarIconBrightness: Brightness.dark,
              ),
              child: Scaffold(
                key: _scaffoldKey,
                appBar: AppBar(
                  backgroundColor: ColorApp.backgroundColor,
                  actions: _buildTopActions(context, uid),
                ),
                body: _buildBody(context, uid),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, String uid) => DefaultTextStyle(
        style: TextStyle(fontSize: 18, color: Colors.black),
        child: WillPopScope(
          onWillPop: () => _onPop(uid),
          child: Container(
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: _buildNoteDetail(),
            ),
          ),
        ),
      );

  Widget _buildNoteDetail() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width / 100 * 100,
            height: MediaQuery.of(context).size.height / 100 * 10,
            child: TextField(
              autocorrect: false,
              enabled: true,
              controller: _titleTextController,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.normal),
                contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                labelText: 'Tiêu đề',
                labelStyle: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.normal),
                prefixIcon: Icon(
                  Icons.create,
                  color: ColorApp.backgroundColor,
                  size: 24,
                ),
                hintText: 'Tiêu đề',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide:
                      BorderSide(width: 1, color: ColorApp.backgroundColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(width: 1, color: Colors.black38),
                ),
                counter: const SizedBox(),
              ),
              maxLines: null,
              maxLength: 1024,
              textCapitalization: TextCapitalization.sentences,
              readOnly: !_note.state.canEdit,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 5, 10),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.grey, width: 0.8),
                borderRadius: BorderRadius.circular(10)),
            child: TextField(
              cursorColor: ColorApp.backgroundColor,
              autocorrect: false,
              controller: _contentTextController,
              style: TextStyle(fontSize: 17),
              decoration: InputDecoration.collapsed(
                  hintText: 'Nội dung',
                  hintStyle: TextStyle(color: Colors.grey),
                  focusColor: ColorApp.backgroundColor),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              readOnly: !_note.state.canEdit,
            ),
          ),
        ],
      );

  List<Widget> _buildTopActions(BuildContext context, String uid) => [
        IconButton(
          icon: const Icon(Icons.more_vert),
          color: Colors.white,
          onPressed: () => _showNoteBottomSheet(context),
        ),
//        if (_note.state != NoteState.deleted)
//          IconButton(
//            icon:
//                Icon(_note.pinned == true ? Icons.offline_pin : Icons.pin_drop),
//            color: Colors.white,
//            tooltip: _note.pinned == true ? 'Unpin' : 'Pin',
//            onPressed: () => _updateNoteState(
//                uid, _note.pinned ? NoteState.unspecified : NoteState.pinned),
//          ),
//        if (_note.id != null && _note.state < NoteState.archived)
//          IconButton(
//            icon: const Icon(Icons.archive, color: Colors.white),
//            tooltip: 'Archive',
//            onPressed: () => Navigator.pop(
//                context,
//                NoteStateUpdateCommand(
//                  id: _note.id,
//                  uid: uid,
//                  from: _note.state,
//                  to: NoteState.archived,
//                )),
//          ),
//        if (_note.state == NoteState.archived)
//          IconButton(
//            icon: const Icon(Icons.assessment),
//            color: Colors.black,
//            tooltip: 'Unarchive',
//            onPressed: () => _updateNoteState(uid, NoteState.unspecified),
//          ),
      ];

  void _showNoteBottomSheet(BuildContext context) async {
    final command = await showModalBottomSheet<NoteCommand>(
      context: context,
      backgroundColor: _noteColor,
      builder: (context) => ChangeNotifierProvider.value(
        value: _note,
        child: Consumer<Note>(
          builder: (_, note, __) => Container(
            color: note.color ?? Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                NoteActions(),
                if (_note.state.canEdit) const SizedBox(height: 16),
                if (_note.state.canEdit) LinearColorPicker(),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );

    if (command != null) {
      if (command.dismiss) {
        Navigator.pop(context, command);
      } else {
        processNoteCommand(_scaffoldKey.currentState, command);
      }
    }
  }

  /// Callback before the user leave the editor.
  Future<bool> _onPop(String uid) {
    if ((_note.id != null || _note.isNotEmpty)) {
      _note..saveToFireStore(uid);
    }
    return Future.value(true);
  }

  void _watchNoteDocument(String uid) {
    if (_noteSubscription == null && uid != null && _note.id != null) {
      _noteSubscription = noteDocument(_note.id, uid)
          .snapshots()
          .map((snapshot) => snapshot.exists ? snapshot.toNote() : null)
          .listen(_onCloudNoteUpdated);
    }
  }

  void _onCloudNoteUpdated(Note note) {
    if (!mounted || note?.isNotEmpty != true || _note == note) {
      return;
    }

    final refresh = () {
      _titleTextController.text = _note.title ?? '';
      _contentTextController.text = _note.content ?? '';

      _note.update(note, updateTimestamp: false);
    };

    if (_isDirty) {
      _scaffoldKey.currentState?.showSnackBar(SnackBar(
        content: const Text('Ghi chú được lưu trữ'),
        action: SnackBarAction(
          label: 'Tải lại',
          onPressed: refresh,
        ),
        duration: const Duration(days: 1),
      ));
    } else {
      refresh();
    }
  }


  void _updateNoteState(uid, NoteState state) {
    // new note, update locally
    if (_note.id == null) {
      _note.updateWith(state: state);
      return;
    }

    // otherwise, handles it in a undoable manner
    processNoteCommand(
        _scaffoldKey.currentState,
        NoteStateUpdateCommand(
          id: _note.id,
          uid: uid,
          from: _note.state,
          to: state,
        ));
  }
}
