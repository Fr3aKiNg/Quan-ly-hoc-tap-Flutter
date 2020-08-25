import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scheduleapp/application/color_app.dart';
import 'package:scheduleapp/data/model/note.dart';
import 'package:scheduleapp/data/model/note_service.dart';
import 'package:scheduleapp/data/model/user.dart';
import 'package:scheduleapp/presentation/atom/bottom_navigation_bar.dart';
import 'package:tuple/tuple.dart';


import 'package:collection_ext/iterables.dart';


import 'note_item.dart';


class NotesList extends StatelessWidget {
  final List<Note> notes;
  final void Function(Note) onTap;

  const NotesList({
    Key key,
    @required this.notes,
    this.onTap,
  }) : super(key: key);

  static NotesList create({
    Key key,
    @required List<Note> notes,
    void Function(Note) onTap,
  }) => NotesList(
    key: key,
    notes: notes,
    onTap: onTap,
  );

  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    sliver: SliverList(
      delegate: SliverChildListDelegate(
        notes.flatMapIndexed((i, note) => <Widget>[
          InkWell(
            onTap: () => onTap?.call(note),
            child: NoteItem(note: note),
          ),
          if (i < notes.length - 1) const SizedBox(height: 10),
        ]).asList(),
      ),
    ),
  );
}

/// Grid view of [Note]s.
class NotesGrid extends StatelessWidget {
  final List<Note> notes;
  final void Function(Note) onTap;

  const NotesGrid({
    Key key,
    @required this.notes,
    this.onTap,
  }) : super(key: key);

  static NotesGrid create({
    Key key,
    @required List<Note> notes,
    void Function(Note) onTap,
  }) => NotesGrid(
    key: key,
    notes: notes,
    onTap: onTap,
  );

  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    sliver: SliverGrid(
      gridDelegate:
      SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200.0,
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 15.0,
        childAspectRatio: 1
      ),
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) => _noteItem(context, notes[index]),
        childCount: notes.length,
      ),
    ),
  );

  Widget _noteItem(BuildContext context, Note note) => InkWell(
    onTap: () => onTap?.call(note),
    child: NoteItem(note: note),
  );
}

class NoteFilter extends ChangeNotifier {
  NoteState _noteState;

  NoteState get noteState => _noteState;
  set noteState(NoteState value) {
    if (value != null && value != _noteState) {
      _noteState = value;
      notifyListeners();
    }
  }
  
  NoteFilter([this._noteState = NoteState.unspecified]);
}

class NoteScreen extends StatefulWidget
 {
  @override
  NoteScreenState createState() {
    return NoteScreenState();
  }
}
class NoteScreenState extends State<NoteScreen> with CommandHandler {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _gridView = true;
  int _selectedItem;

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle.dark.copyWith(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
    child: MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NoteFilter(), // watching the note filter
        ),
        Consumer<NoteFilter>(
          builder: (context, filter, child) => StreamProvider.value(
            value: _createNoteStream(context), // applying the filter to Firestore query
            child: child,
          ),
        ),
      ],
      child: Consumer2<NoteFilter, List<Note>>(
        builder: (context, filter, notes, child) {
          final hasNotes = notes?.isNotEmpty == true;
          final canCreate = filter.noteState.canCreate;
          return Scaffold(bottomNavigationBar:BottomAppBar(
            child:
              CustomBottomNavigationBar(
                iconList: [
                  Icons.home,
                  Icons.assessment,
                  Icons.note,
                  Icons.dashboard,
                ],
                onChange: (val) {
                  setState(() {
                    _selectedItem = val;
                  });
                },
                defaultSelectedIndex: 2,
                btnName: ["Tổng quan","Điểm","Ghi chú","Khác"],
              ),
          ),
            key: _scaffoldKey,
            body: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints.tightFor(width: 720),
                child: CustomScrollView(
                  slivers: <Widget>[
                    _appBar(context, filter, child),
                    if (hasNotes) const SliverToBoxAdapter(
                      child: SizedBox(height: 24),
                    ),
                    ..._buildNotesView(context, filter, notes),
                    if (hasNotes) SliverToBoxAdapter(
                      child: SizedBox(height: (canCreate ? 56 : 10.0) + 10.0),
                    ),
                  ],
                ),
              ),
            ),
//            drawer: AppDrawer(),
            floatingActionButton: canCreate ? _fab(context) : null,
            /**floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,**/
            extendBody: true,
          );
        },
      ),
    ),
  );

  Widget _appBar(BuildContext context, NoteFilter filter, Widget bottom) =>
      filter.noteState < NoteState.archived
          ? SliverAppBar(
        floating: true,
        snap: true,
        title: _topActions(context),
        automaticallyImplyLeading: false,
        centerTitle: true,
        titleSpacing: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
      )
          :
      SliverAppBar(
        floating: true,
        snap: true,
        title: Text(filter.noteState.filterName),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          tooltip: 'Menu',
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        automaticallyImplyLeading: false,
      );

  Widget _topActions(BuildContext context) => Container(
    width: MediaQuery.of(context).size.width,
    constraints: const BoxConstraints(
      maxWidth: 720,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 0),
    child: Card(color: ColorApp.backgroundColor,
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
        child: Row(
          children: <Widget>[
            const SizedBox(width: 10),
            const Expanded(
              child: Text('Ghi chú',
                softWrap: false,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(width: 16),
            const SizedBox(width: 18),
            _buildAvatar(context),
            const SizedBox(width: 10),
          ],
        ),
      ),
    ),
  );

  Widget _fab(BuildContext context) =>
      Transform.translate(offset: Offset(3,-35) ,
        child: FloatingActionButton(
            key: UniqueKey(),
            backgroundColor: ColorApp.backgroundColor,
            elevation: 0,
            child: Icon(Icons.add,size: 24),
            onPressed: () async {
              final command = await Navigator.pushNamed(context, '/note');
              processNoteCommand(_scaffoldKey.currentState, command);
            },
          ),
      );

  Widget _buildAvatar(BuildContext context) {
    final url = Provider.of<CurrentUser>(context)?.data?.photoUrl;
    return CircleAvatar(
      backgroundImage: url != null ? NetworkImage(url) : null,
      child: url == null ? const Icon(Icons.face) : null,
      radius:  20,
    );
  }

  List<Widget> _buildNotesView(BuildContext context, NoteFilter filter, List<Note> notes) {
    if (notes?.isNotEmpty != true) {
      return [_buildBlankView(filter.noteState)];
    }

    final asGrid = filter.noteState == NoteState.deleted || _gridView;
    final factory = asGrid ? NotesGrid.create : NotesList.create;
    final showPinned = filter.noteState == NoteState.unspecified;

    if (!showPinned) {
      return [
        factory(notes: notes, onTap: _onNoteTap),
      ];
    }

    final partition = _partitionNotes(notes);
    final hasPinned = partition.item1.isNotEmpty;
    final hasUnpinned = partition.item2.isNotEmpty;

    final _buildLabel = (String label, [double top = 26]) => SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsetsDirectional.only(start: 26, bottom: 25, top: top),
        child: Text(label, style: const TextStyle(

            fontWeight: FontWeight.w600,
            fontSize: 12),
        ),
      ),
    );

    return [
      if (hasPinned) _buildLabel('PINNED', 0),
      if (hasPinned) factory(notes: partition.item1, onTap: _onNoteTap),
      if (hasPinned && hasUnpinned) _buildLabel('OTHERS'),
      factory(notes: partition.item2, onTap: _onNoteTap),
    ];
  }

  Widget _buildBlankView(NoteState filteredState) => SliverFillRemaining(
    hasScrollBody: false,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Expanded(flex: 1, child: SizedBox()),
      SizedBox(width: 150,height: 150,child: Image.asset("assets/empty.jpg"),),
        Expanded(
          flex: 2,
          child: Text("Bạn chưa có ghi chú nào. Hãy tạo ghi chú !",
            style: TextStyle(
//              color: kHintTextColorLight,
              fontSize: 14,
            ),
          ),
        ),
      ],
    ),
  );

  /// Callback on a single note clicked
  void _onNoteTap(Note note) async {
    final command = await Navigator.pushNamed(context, '/note', arguments: { 'note': note });
    processNoteCommand(_scaffoldKey.currentState, command);
  }

  /// Create notes query
//  Stream<List<Note>> _createNoteStream(BuildContext context, NoteFilter filter) {
//    final user = Provider.of<CurrentUser>(context)?.data;
//    final sinceSignUp = DateTime.now().millisecondsSinceEpoch -
//        (user?.metadata?.creationTime?.millisecondsSinceEpoch ?? 0);
//    final useIndexes = sinceSignUp >= _10_min_millis; // since creating indexes takes time, avoid using composite index until later
//    final collection = notesCollection(user?.uid);
//    final query = filter.noteState == NoteState.unspecified
//        ? collection
//        .where('state', isLessThan: NoteState.archived.index) // show both normal/pinned notes when no filter specified
//        .orderBy('state', descending: true) // pinned notes come first
//        : collection.where('state', isEqualTo: filter.noteState.index);
//
//    return (useIndexes ? query.orderBy('createdAt', descending: true) : query)
//        .snapshots()
//        .handleError((e) => debugPrint('query notes failed: $e'))
//        .map((snapshot) => Note.fromQuery(snapshot));
//  }

  Stream<List<Note>> _createNoteStream(BuildContext context) {
    final uid = Provider.of<CurrentUser>(context)?.data?.uid;
    return Firestore.instance.collection('notes-$uid')
        .where('state', isEqualTo: 0)
        .snapshots()
        .handleError((e) => debugPrint('query notes failed: $e'))
        .map((snapshot) => Note.fromQuery(snapshot));
  }
  /// Partition the note list by the pinned state
  Tuple2<List<Note>, List<Note>> _partitionNotes(List<Note> notes) {
    if (notes?.isNotEmpty != true) {
      return Tuple2([], []);
    }

    final indexUnpinned = notes?.indexWhere((n) => !n.pinned);
    return indexUnpinned > -1
        ? Tuple2(notes.sublist(0, indexUnpinned), notes.sublist(indexUnpinned))
        : Tuple2(notes, []);
  }
}

const _10_min_millis = 600000;

//{
//
//  Widget build(BuildContext context) => StreamProvider.value(
//    value: FirebaseAuth.instance.onAuthStateChanged.map((user) => CurrentUser.create(user)),
//    initialData: CurrentUser.initial,
//    child: Consumer<CurrentUser>(
//      builder: (context, user, _) => MaterialApp(
//        title: 'Flutter Keep',
//        theme: Theme.of(context).copyWith(
//          brightness: Brightness.light,
//          primaryColor: Colors.white,
//          appBarTheme: AppBarTheme.of(context).copyWith(
//            elevation: 0,
//            brightness: Brightness.light,
//          ),
//          scaffoldBackgroundColor: Colors.white,
//          primaryTextTheme: Theme.of(context).primaryTextTheme.copyWith(
//          ),
//        ),
//        home: user.isInitialValue
//            ? Scaffold(body: const SizedBox(),floatingActionButton:
//          FloatingActionButton(backgroundColor: ColorApp.Blue,
//            child: Icon(Icons.add,size: 24,color: Colors.white),
//            onPressed: ()
//            {
//              Navigator.of(context).pushNamed('note_editor');
//            },
//          ),)
//            : user.data != null ? HomeScreen() : null,
//        routes: {
//
//        },
//        onGenerateRoute: _generateRoute,
//      ),
//    ),
//  );
//  Route _doGenerateRoute(RouteSettings settings) {
//    if (settings.name?.isNotEmpty != true) return null;
//
//    final uri = Uri.parse(settings.name);
//    final path = uri.path ?? '';
//    // final q = uri.queryParameters ?? <String, String>{};
//    switch (path) {
//      case '/note': {
//        final note = (settings.arguments as Map ?? {})['note'];
//        return _buildRoute(settings, (_) => NoteEditor(note: note));
//      }
//      default:
//        return null;
//    }
//  }
//  Route _generateRoute(RouteSettings settings) {
//    try {
//      return _doGenerateRoute(settings);
//    } catch (e, s) {
//      debugPrint("failed to generate route for $settings: $e $s");
//      return null;
//    }
//  }
//  Route _buildRoute(RouteSettings settings, WidgetBuilder builder) =>
//      MaterialPageRoute<void>(
//        settings: settings,
//        builder: builder,
//      );
//}