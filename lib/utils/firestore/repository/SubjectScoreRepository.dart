import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scheduleapp/utils/firestore/models/subject_score.dart';

class SubjectScoreRepository{
  final CollectionReference collection = Firestore.instance.collection('subjectScores');
  // 2
  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }
  // 3
  Future<DocumentReference> addPet(SubjectScore value) {
    return collection.add(value.toJson());
  }
  // 4
  updatePet(SubjectScore value) async {
    collection.document(value.reference.documentID).updateData(value.toJson());
  }
}