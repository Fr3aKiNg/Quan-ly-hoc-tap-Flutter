import 'package:firebase_auth/firebase_auth.dart';

class CurrentUser {
  final bool isInitialValue;
  final FirebaseUser data;

  const CurrentUser._(this.data,this.isInitialValue);
  factory CurrentUser.create(FirebaseUser data)
  => CurrentUser._(data,false);


  static const initial = CurrentUser._(null,true);
}