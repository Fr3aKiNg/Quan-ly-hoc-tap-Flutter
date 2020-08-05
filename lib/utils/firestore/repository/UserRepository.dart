import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scheduleapp/utils/firestore/models/user.dart';

class UserRepository{
  final CollectionReference collection = Firestore.instance.collection('users');
  // 2
  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }
  // 3
  Future<DocumentReference> addPet(User user) {
    return collection.add(user.toJson());
  }
  // 4
  updatePet(User user) async {
    collection.document(user.reference.documentID).updateData(user.toJson());
  }
}