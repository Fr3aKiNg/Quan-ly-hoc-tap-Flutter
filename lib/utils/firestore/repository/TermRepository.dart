import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scheduleapp/utils/firestore/models/term.dart';

class TermRepository{
  final CollectionReference collection = Firestore.instance.collection('terms');
  // 2
  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }
  // 3
  Future<DocumentReference> addPet(Term term) {
    return collection.add(term.toJson());
  }
  // 4
  updatePet(Term term) async {
    collection.document(term.reference.documentID).updateData(term.toJson());
  }
}