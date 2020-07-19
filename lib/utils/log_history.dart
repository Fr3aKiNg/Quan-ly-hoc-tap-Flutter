import 'package:Educare/utils/app_constant.dart';
class LogHistory {
    static void trackLog(String entity,String content){
      var now = DateTime.now();
      var buildLog = "[LOG] "+now.toString()+" | "+entity+" "+content;
      if(DEBUG_MODE) print(buildLog);
    }
}