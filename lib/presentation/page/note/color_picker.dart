import 'package:collection_ext/iterables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scheduleapp/data/model/note.dart';



/// Note color picker in a horizontal list style.
class LinearColorPicker extends StatelessWidget {
  /// Returns color of the note, fallbacks to the default color.
  Color _currColor(Note note) => note?.color ?? Colors.white;
  final colors = [
    Color(0xffffffff), // classic white
    Color(0xfff28b81), // light pink
    Color(0xfff7bd02), // yellow
    Color(0xfffbf476), // light yellow
    Color(0xffcdff90), // light green
    Color(0xffa7feeb), // turquoise
    Color(0xffcbf0f8), // light cyan
    Color(0xffafcbfa), // light blue
    Color(0xffd7aefc), // plum
    Color(0xfffbcfe9), // misty rose
    Color(0xffe6c9a9), // light brown
    Color(0xffe9eaee) // light gray
  ];
  @override
  Widget build(BuildContext context) {
    Note note = Provider.of<Note>(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: colors.flatMapIndexed((i, color) => [
          if (i == 0) const SizedBox(width: 17),
          InkWell(
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xffd3d3d3)),
              ),
              child: color == _currColor(note) ? const Icon(Icons.check, color: Color(0xffd3d3d3)) : null,
            ),
            onTap: () {
              if (color != _currColor(note)) {
                note.updateWith(color: color);
              }
            },
          ),
          SizedBox(width: i == colors.length - 1 ? 17 : 20),
        ]).asList(),
      ),
    );
  }
}
