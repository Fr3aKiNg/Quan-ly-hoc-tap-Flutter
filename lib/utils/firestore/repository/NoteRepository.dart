import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scheduleapp/utils/firestore/models/note.dart';

class NoteRepository{
  final CollectionReference collection = Firestore.instance.collection('notes');
  // 2
  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }
  // 3
  Future<DocumentReference> addPet(Note value) {
    return collection.add(value.toJson());
  }
  // 4
  updatePet(Note value) async {
    collection.document(value.reference.documentID).updateData(value.toJson());
  }
}