import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scheduleapp/utils/firestore/models/subject_score.dart';

class Subject{
  String id;
  String name;
  double goal;

  List<SubjectScore> subjectScores = List<SubjectScore>();

  DocumentReference reference;
  Subject(this.name, this.goal, this.subjectScores);
  factory Subject.fromSnapshot(DocumentSnapshot snapshot){
    Subject newSubject = Subject.fromJson(snapshot.data);
    newSubject.reference = snapshot.reference;
    newSubject.id = snapshot.documentID;
    return newSubject;
  }
  factory Subject.fromJson(Map<dynamic, dynamic> json) => _SubjectFromJson(json);
  Map<String, dynamic> toJson() => _SubjectToJson(this);
  @override
  String toString() => "Subject<$name>";
}
// 1
Subject _SubjectFromJson(Map<String, dynamic> json) {
  return Subject(
      json['name'] as String,
     json['goal'] as double,
    _convertSubjectScores(json['subjectScores']) as List
  );
}
// 2
List<SubjectScore> _convertSubjectScores(List subjectScoreMap) {
  if (subjectScoreMap == null) {
    return null;
  }
  List<SubjectScore> subjectScores =  List<SubjectScore>();
  subjectScoreMap.forEach((value) {
    subjectScores.add(SubjectScore.fromJson(value));
  });
  return subjectScores;
}
// 3
Map<String, dynamic> _SubjectToJson(Subject instance) => <String, dynamic> {
  'name': instance.name,
  'goal': instance.goal,
  'subjectScores': _SubjectScoreList(instance.subjectScores),
};
// 4
List<Map<String, dynamic>> _SubjectScoreList(List<SubjectScore> SubjectScores) {
  if (SubjectScores == null) {
    return null;
  }
  List<Map<String, dynamic>> SubjectScoreMap =List<Map<String, dynamic>>();
  SubjectScores.forEach((SubjectScore) {
    SubjectScoreMap.add(SubjectScore.toJson());
  });
  return SubjectScoreMap;
}
