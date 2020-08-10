import 'package:flutter/material.dart';

import 'package:scheduleapp/data/model/note.dart';

/// A single item (preview of a Note) in the Notes list.
class NoteItem extends StatelessWidget {
  const NoteItem({
    Key key,
    this.note,
  }) : super(key: key);

  final Note note;

  @override
  Widget build(BuildContext context) => Hero(
    tag: 'NoteItem${note.id}',
    child: DefaultTextStyle(
      style: TextStyle(fontSize: 18,color: Colors.black),
      child: Container(
        decoration: BoxDecoration(
          color: note.color,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          border: note.color.value == 0xFFFFFFFF ? Border.all(color: Colors.black) : Border.all(color: Colors.white),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (note.title?.isNotEmpty == true) Text(note.title,
              style: TextStyle(fontSize: 16,color: Colors.black),
              maxLines: 1,
            ),
            if (note.title?.isNotEmpty == true) const SizedBox(height: 14),
            Flexible(
              flex: 1,
              child: Text(note.content ?? '',style: TextStyle(color: Colors.black),), // wrapping using a Flexible to avoid overflow
            ),
          ],
        ),
      ),
    ),
  );
}
