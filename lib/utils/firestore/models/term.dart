import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scheduleapp/utils/firestore/models/subject.dart';

class Term{
  String id;
  int grade;
  int term;

  List<Subject> subjects = List<Subject>();
  DocumentReference reference;

  Term(this.grade, this.term, this.subjects);
  factory Term.fromSnapshot(DocumentSnapshot snapshot){
    Term newTerm = Term.fromJson(snapshot.data);
    newTerm.reference = snapshot.reference;
    newTerm.id = snapshot.documentID;
    return newTerm;
  }
  factory Term.fromJson(Map<String, dynamic> json) => _TermFromJson(json);
  Map<String, dynamic> toJson() => _TermToJson(this);
  @override
  String toString()=> "Term<$grade><$term>";
}
// 1
Term _TermFromJson(Map<String, dynamic> json) {
  return Term(
      json['grade'] as int,
      json['term'] as int,
      _convertSubjects(json['subjects'] as List)
  );
}
// 2
List<Subject> _convertSubjects(List subjectMap) {
  if (subjectMap == null) {
    return null;
  }
  List<Subject> subject =  List<Subject>();
  subjectMap.forEach((value) {
    subject.add(Subject.fromJson(value));
  });
  return subject;
}
// 3
Map<String, dynamic> _TermToJson(Term instance) => <String, dynamic> {
  'grade': instance.grade,
  'term': instance.term,
  'subjects': _SubjectList(instance.subjects),
};
// 4
List<Map<String, dynamic>> _SubjectList(List<Subject> subject) {
  if (subject == null) {
    return null;
  }
  List<Map<String, dynamic>> subjectMap =List<Map<String, dynamic>>();
  subject.forEach((value) {
    subjectMap.add(value.toJson());
  });
  return subjectMap;
}
