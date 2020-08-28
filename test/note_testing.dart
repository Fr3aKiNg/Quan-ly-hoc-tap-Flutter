import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_test/flutter_test.dart';


 void main() async {TestWidgetsFlutterBinding.ensureInitialized();
  final uid = '60CSFzxUmvSU9HzBx6sOq54TEso2';
  test("test grade", () async{
    final snapshot = (await Firestore.instance
        .collection('note1')
        .document('note1')
        .collection('title').getDocuments());
    expect(snapshot,'note1');
  });
}