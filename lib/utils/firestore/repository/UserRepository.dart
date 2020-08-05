import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:scheduleapp/utils/firestore/models/user.dart';

class UserRepository extends ChangeNotifier{
  final CollectionReference collection = Firestore.instance.collection('users');

  List<User> users;

  Future<List<User>> fetchUsers() async{
    var result = await getAllDocument();
    users = result.documents
        .map((doc) => User.fromJson(doc.data))
        .toList();
    return users;
  }
  Stream<QuerySnapshot> fetchUsersAsStream(){
    return getStream();
  }
  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }
  Future<QuerySnapshot> getAllDocument() {
    return collection.getDocuments() ;
  }
  removeDocument(String id) async {
    collection.document(id).delete();
  }
  Future<DocumentSnapshot> getDocumentById(String id) async {
    return collection.document(id).get();
  }
  Future<User> getUserById(String id) async {
    return User.fromSnapshot(await getDocumentById(id));
  }
  Future<DocumentReference> addDocument(User user) async {
    return collection.add(user.toJson());
  }

  updateDocument(User user) async {
    collection.document(user.reference.documentID).updateData(user.toJson());
  }
}