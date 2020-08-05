import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectScore{
  String type;
  double score;

  DocumentReference reference;
  SubjectScore(this.type,this.score);
  factory SubjectScore.fromJson(Map<dynamic, dynamic> json) => _SubjectScoreFromJson(json);
  Map<String, dynamic> toJson() => _SubjectScoreToJson(this);
  @override
  String toString() => "SubjectScore<$type><$score>";
}
SubjectScore _SubjectScoreFromJson(Map<dynamic, dynamic> json) {
  return SubjectScore(
    json['type'] as String,
    json['score'] as double
  );
}
//2
Map<String, dynamic> _SubjectScoreToJson(SubjectScore instance) =>
    <String, dynamic> {
      'type': instance.type,
      'score': instance.score,
    };