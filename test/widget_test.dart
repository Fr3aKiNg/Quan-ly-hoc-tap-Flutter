// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:scheduleapp/main.dart';

void main() {
  // testWidgets('Counter increments smoke test', () {
    final uid = '60CSFzxUmvSU9HzBx6sOq54TEso2';
    final firestore = MockFirestoreInstance();
    testWidgets("show note", (WidgetTester tester) async {
      final snapshot = (await firestore
          .collection('users')
          .document(uid)
          .collection('name').getDocuments());
//    await firestore.collection('notes-$uid').document('HL4KXeP6OT8myZkdKiTK').setData({
//      'color': '4294967295',
//      'content': "Test data of note",
//      'state':'0',
//      'title':'Unit Testing'
//    });
      expect(snapshot.documents.toString(), equals('Binh Trinh'));
      // // Verify the output.
//    expect(firestore.dump(), equals(expectedDumpAfterSetData));
      });
  }

