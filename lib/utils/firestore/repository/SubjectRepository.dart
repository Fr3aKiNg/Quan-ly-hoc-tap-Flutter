import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scheduleapp/utils/firestore/models/subject.dart';

class SubjectRepository{
  final CollectionReference collection = Firestore.instance.collection('subjects');
  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }
  Future<QuerySnapshot> getAllDocument() {
    return collection.getDocuments() ;
  }
  removeDocument(String id) async {
    collection.document(id).delete();
  }
  Future<DocumentSnapshot> getDocumentById(String id) {
    return collection.document(id).get();
  }
  Stream<List<Subject>> streamOfSubjects(){
    return getStream().map((list) => list.documents.map((doc) => Subject.fromSnapshot(doc)).toList());
  }
  Future<DocumentReference> addPet(Subject value) {
    return collection.add(value.toJson());
  }
  // 4
  updatePet(Subject value) async {
    collection.document(value.reference.documentID).updateData(value.toJson());
  }
}