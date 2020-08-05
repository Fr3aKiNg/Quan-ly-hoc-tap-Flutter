import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:scheduleapp/utils/firestore/models/term.dart';

class User{
  String email;
  String name;
  String imageUrl;
  List<Term> terms = List<Term>();
  DocumentReference reference;
  User(this.email, this.name,this.imageUrl,this.terms);
  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    User newUser = User.fromJson(snapshot.data);
    newUser.reference = snapshot.reference;
    return newUser;
  }
  factory User.fromJson(Map<dynamic, dynamic> json) => _UserFromJson(json);
  Map<String, dynamic> toJson() => _UserToJson(this);
  @override
  String toString() => "User<$email>";
}
User _UserFromJson(Map<dynamic, dynamic> json) {
  return User(
    json['email'] as String,
    json['name'] as String,
    json['imageUrl'] as String,
    _convertTerms(json['terms'] as List)
  );
}
List<Term> _convertTerms(List termMap) {
  if (termMap == null) {
    return null;
  }
  List<Term> terms =  List<Term>();
  termMap.forEach((value) {
    terms.add(Term.fromJson(value));
  });
  return terms;
}
//2
Map<String, dynamic> _UserToJson(User instance) =>
    <String, dynamic> {
      'email': instance.email,
      'name': instance.name,
      'imageUrl': instance.imageUrl ,
      'terms': _TermList(instance.terms)
    };

List<Map<String, dynamic>> _TermList(List<Term> terms) {
  if (terms == null) {
    return null;
  }
  List<Map<String, dynamic>> termMap =List<Map<String, dynamic>>();
  terms.forEach((term) {
    termMap.add(term.toJson());
  });
  return termMap;
}