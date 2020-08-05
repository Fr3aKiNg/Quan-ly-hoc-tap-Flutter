import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scheduleapp/utils/firestore/models/event.dart';

class EventRepository{
  final CollectionReference collection = Firestore.instance.collection('events');
  // 2
  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }
  // 3
  Future<DocumentReference> addPet(Event value) {
    return collection.add(value.toJson());
  }
  // 4
  updatePet(Event value) async {
    collection.document(value.reference.documentID).updateData(value.toJson());
  }
}