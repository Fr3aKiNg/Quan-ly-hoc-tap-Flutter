class User{
  ///0 = non-login
  ///1 = login
  static int state = 0;
  final uid;
  final userName;

  User(this.uid, this.userName);
  bool checkPermission(){
    return false;
  }

}