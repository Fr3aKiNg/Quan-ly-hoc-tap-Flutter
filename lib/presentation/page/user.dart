import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
final FirebaseAuth auth = FirebaseAuth.instance;

class User {
  String id;
  String name;
  String school;
  String grade;
  int numSemester;
  List expectedScore;
  User (){
  }
  void setUid() async {
    final FirebaseUser user = await auth.currentUser();
    this.id = user.uid;
  }

  void setInitValue (String name, String school, String grade, int numSes)  {
    this.name = name;
    this.school = school;
    this.grade = grade;
    this.numSemester = numSes;
    this.expectedScore = ["-","-","-"];
  }

  Future<bool> isExist() async{
    Firestore.instance.collection("users").document(this.id).get().then((value) {
      return value;
    });
  }

  void createUser() async {
    final collection = Firestore.instance.collection("users");
    final FirebaseUser user = await auth.currentUser();
    this.id = user.uid;
    collection.document(this.id).setData({
      "name": this.name,
      "school": this.school,
      "grade": this.grade,
      "numOfSemester": this.numSemester,
      "expectedScore" : {
        "term 1": this.expectedScore[0],
        "term 2": this.expectedScore[1],
        "term 3": this.expectedScore[2],
      }
    });
  }

  void addCourse(Set<String> course) async {
    final collection = Firestore.instance.collection("users");
    final FirebaseUser user = await auth.currentUser();
    this.id = user.uid;
    final data = [];
    final dataScore = {};
    final dataOverall = {};
    final dataColumn = {};
    List courses = course.toList();
    for (int i = 0; i < course.length; i++) {
      data.add(courses[i]);
      dataScore.addAll({
        courses[i]: {
          "Miệng": [],
          "15 phút": [],
          "1 tiết": [],
          "Giữa kì": [],
          "Cuối kì": [],
        }
      });
      dataOverall.addAll({
        courses[i]: "-"
      });
      dataColumn.addAll({
        courses[i] : {
          "column": ["Miệng","15 phút","1 tiết","Giữa kì","Cuối kì"],
          "coef": [1,1,2,2,3]
        },
      });
    }
    final dataYear = {
      "HK1": {
        "ingredientScore": dataScore,
        "final": "-",
      },
      "HK2": {
        "ingredientScore": dataScore,
        "final": "-",
      },
      "overall": {
        "ingredientScore": dataOverall,
        "final": "-",
      },
      "coefficient": {
        "HK1": 1,
        "HK2": 2
      }
    };
    collection.document(this.id).updateData({
      "course" : data,
      "year1": dataYear,
      "year2": dataYear,
      "year3": dataYear,
      "columnScore": dataColumn
    });
  }

  void addExpectedScore(String score1, String score2, String score3, String id) {
    final collection = Firestore.instance.collection("users");
    collection.document(id).updateData({
      "expectedScore" : {
        "term 1": score1,
        "term 2": score2,
        "term 3": score3
      }
    });
  }

  void updateCoefficient(String uid, List coef) {
    final collection = Firestore.instance.collection("users");
    collection.document(uid).updateData({
      "year1.coefficient.HK1": coef[0][0],
      "year1.coefficient.HK2": coef[0][1],
      "year2.coefficient.HK1": coef[1][0],
      "year2.coefficient.HK2": coef[1][1],
      "year3.coefficient.HK1": coef[2][0],
      "year3.coefficient.HK2": coef[2][1],
    });
  }

  void addNewCourse(String newName, List column, List coef) async {
    final collection = Firestore.instance.collection("users");
    final FirebaseUser user = await auth.currentUser();
    this.id = user.uid;
    String temp11 = "year1.HK1.ingredientScore."+newName;
    String temp12 = "year1.HK2.ingredientScore."+newName;
    String temp13 = "year1.overall.ingredientScore."+newName;
    String temp21 = "year2.HK1.ingredientScore."+newName;
    String temp22 = "year2.HK2.ingredientScore."+newName;
    String temp23 = "year2.overall.ingredientScore."+newName;
    String temp31 = "year3.HK1.ingredientScore."+newName;
    String temp32 = "year3.HK2.ingredientScore."+newName;
    String temp33 = "year3.overall.ingredientScore."+newName;

    String tempColumnScore = "columnScore."+newName;
    final dataYear = {};
    for (int i = 0; i < column.length; i++) {
      dataYear.addAll({
        column[i] : [],
      });
    }
    collection.document(this.id).updateData({
      "course" : FieldValue.arrayUnion([newName]),
      tempColumnScore : {
          "coef":coef,
          "column":column
      },
      temp11: dataYear,
      temp12: dataYear,
      temp13: "-",
      temp21: dataYear,
      temp22: dataYear,
      temp23: "-",
      temp32: dataYear,
      temp31: dataYear,
      temp33: "-"
      ,
    });
  }

  void updateScore(String uid, String courseName, List score1, List score2, List nameCol, int chosenYear) {
    final collection = Firestore.instance.collection("users");
    final data = {};
    final data2 = {};
    for (int i = 0; i < nameCol.length; i++) {
      data.addAll({
        nameCol[i]: score1[i],
      });
      data2.addAll({
        nameCol[i]: score2[i],
      });
    }
    String query1 = "year1.HK1.ingredientScore."+courseName;
    String query2 = "year1.HK2.ingredientScore."+courseName;

    String query3 = "year2.HK1.ingredientScore."+courseName;
    String query4 = "year2.HK2.ingredientScore."+courseName;

    String query5 = "year3.HK1.ingredientScore."+courseName;
    String query6 = "year3.HK2.ingredientScore."+courseName;

    if (chosenYear == 0) {
      collection.document(uid).updateData({
        query1: data,
        query2: data2,
      });
    }
    else if (chosenYear == 1) {
      collection.document(uid).updateData({
        query3: data,
        query4: data2,
      });
    }
    else {
      collection.document(uid).updateData({
        query5: data,
        query6: data2,
      });
    }
  }

  void editCourse(String uid, String courseName, List nameCol, List coef, String newCourse, bool isRename) {
    final collection = Firestore.instance.collection("users");
    String query1 = "columnScore."+courseName;
    String query2, query3, query4, query5, query6, query7, query8;
    if (!isRename){
      query2 = "year1.HK1.ingredientScore."+courseName;
      query3 = "year1.HK2.ingredientScore."+courseName;
      query4 = "year2.HK1.ingredientScore."+courseName;
      query5 = "year2.HK2.ingredientScore."+courseName;
      query6 = "year3.HK1.ingredientScore."+courseName;
      query7 = "year3.HK2.ingredientScore."+courseName;
      query8 = "columnScore."+courseName;
    }
    else {
      query2 = "year1.HK1.ingredientScore."+newCourse;
      query3 = "year1.HK2.ingredientScore."+newCourse;
      query4 = "year2.HK1.ingredientScore."+newCourse;
      query5 = "year2.HK2.ingredientScore."+newCourse;
      query6 = "year3.HK1.ingredientScore."+newCourse;
      query7 = "year3.HK2.ingredientScore."+newCourse;
      query8 = "columnScore."+newCourse;
    }


    final data1 = {};
    final data2 = {};
    final data3 = {};
    final data4 = {};
    final data5 = {};
    final data6 = {};
    final data7 = {};
    collection.document(uid).get().then((value) {
      for (int i = 0; i < nameCol.length; i++){
        data1.addAll({
          nameCol[i]: value.data["year1"]["HK1"]["ingredientScore"][courseName][nameCol[i]],
        });
        data2.addAll({
          nameCol[i]: value.data["year1"]["HK2"]["ingredientScore"][courseName][nameCol[i]],
        });
        data3.addAll({
          nameCol[i]: value.data["year2"]["HK1"]["ingredientScore"][courseName][nameCol[i]],
        });
        data4.addAll({
          nameCol[i]: value.data["year2"]["HK2"]["ingredientScore"][courseName][nameCol[i]],
        });
        data5.addAll({
          nameCol[i]: value.data["year3"]["HK1"]["ingredientScore"][courseName][nameCol[i]],
        });
        data6.addAll({
          nameCol[i]: value.data["year3"]["HK2"]["ingredientScore"][courseName][nameCol[i]],
        });
      }
      data7.addAll({
        "coef": coef,
        "column": nameCol
      });

      collection.document(uid).updateData({
        query1: {
          "coef": coef,
          "column": nameCol,
        },
        query2: data1,
        query3: data2,
        query4: data3,
        query5: data4,
        query6: data5,
        query7: data6,
        query8: data7,
        "course": FieldValue.arrayUnion([newCourse])
      }).then((_) {
        if (isRename) {
          String query1 = "columnScore." + courseName;

          String query21 = "year1.HK1.ingredientScore."+ courseName;
          String query22 = "year1.HK2.ingredientScore."+ courseName;
          String query23 = "year1.overall.ingredientScore."+ courseName;

          String query31 = "year2.HK1.ingredientScore."+ courseName;
          String query32 = "year2.HK2.ingredientScore."+ courseName;
          String query33 = "year2.overall.ingredientScore."+ courseName;

          String query41 = "year3.HK1.ingredientScore."+ courseName;
          String query42 = "year3.HK2.ingredientScore."+ courseName;
          String query43 = "year3.overall.ingredientScore."+ courseName;

          collection.document(uid).updateData({
            query1: FieldValue.delete(),
            "course": FieldValue.arrayRemove([courseName]),
            query21: FieldValue.delete(),
            query22: FieldValue.delete(),
            query23: FieldValue.delete(),
            query31: FieldValue.delete(),
            query32: FieldValue.delete(),
            query33: FieldValue.delete(),
            query41: FieldValue.delete(),
            query42: FieldValue.delete(),
            query43: FieldValue.delete(),
          });
        }
        else {
          collection.document(uid).updateData({
            "course": FieldValue.arrayRemove([newCourse])
          });
        }
      });
    });
  }

  void deleteCourse(String uid, String oldName){
    final collection = Firestore.instance.collection("users");
    String query1 = "columnScore." + oldName;

    String query21 = "year1.HK1.ingredientScore."+ oldName;
    String query22 = "year1.HK2.ingredientScore."+ oldName;
    String query23 = "year1.overall.ingredientScore."+ oldName;

    String query31 = "year2.HK1.ingredientScore."+ oldName;
    String query32 = "year2.HK2.ingredientScore."+ oldName;
    String query33 = "year2.overall.ingredientScore."+ oldName;

    String query41 = "year3.HK1.ingredientScore."+ oldName;
    String query42 = "year3.HK2.ingredientScore."+ oldName;
    String query43 = "year3.overall.ingredientScore."+ oldName;

    collection.document(uid).updateData({
      query1: FieldValue.delete(),
      "course": FieldValue.arrayRemove([oldName]),
      query21: FieldValue.delete(),
      query22: FieldValue.delete(),
      query23: FieldValue.delete(),
      query31: FieldValue.delete(),
      query32: FieldValue.delete(),
      query33: FieldValue.delete(),
      query41: FieldValue.delete(),
      query42: FieldValue.delete(),
      query43: FieldValue.delete(),
    });
  }
}