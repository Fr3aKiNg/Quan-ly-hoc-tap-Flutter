class LogHistory {
    static void trackLog(String entity,String content){
      var now = DateTime.now();
      var buildLog = "[LOG] "+now.toString()+" | "+entity+" "+content;
      print(buildLog);
    }
}