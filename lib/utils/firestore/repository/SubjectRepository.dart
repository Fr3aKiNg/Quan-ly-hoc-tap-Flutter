import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scheduleapp/utils/firestore/models/subject.dart';

class SubjectRepository{
  final CollectionReference collection = Firestore.instance.collection('subjects');
  // 2
  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }
  // 3
  Future<DocumentReference> addPet(Subject value) {
    return collection.add(value.toJson());
  }
  // 4
  updatePet(Subject value) async {
    collection.document(value.reference.documentID).updateData(value.toJson());
  }
}