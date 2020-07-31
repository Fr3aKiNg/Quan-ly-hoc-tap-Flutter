import 'TimeUtils.dart';

class User extends TimeUtils{
  ///0 = non-login
  ///1 = login
  static int state = 0;
  final uid;
  final userName;
  String password;
  String email;

  User(this.uid, this.userName,);
  bool checkPermission(){
    return false;
  }

}