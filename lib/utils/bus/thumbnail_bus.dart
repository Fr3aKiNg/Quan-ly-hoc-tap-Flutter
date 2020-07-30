
import 'dart:async';

import 'package:scheduleapp/utils/model/thumbnailNote.dart';
import 'package:scheduleapp/utils/repository/thumnail_repo.dart';
import 'package:scheduleapp/utils/app_constant.dart';
class ThumbnailBUS {
  final _thumbnailRepository = ThumbnailRepository();

  getThumbnailsByTag(String tagId) async{
    if(DEBUG_MODE) {
      final stopwatch = Stopwatch()
        ..start();
      var res = await _thumbnailRepository.findThumbnailByTagId(tagId);
      print('[Time] Query Search by Tag executed in ${stopwatch.elapsed}');
      stopwatch.stop();
      return res;
    }else{
      var res = await _thumbnailRepository.findThumbnailByTagId(tagId);
      return res;
    }
  }

  getThumbnailsByKeyWordAll(String keyword) async{
    if(DEBUG_MODE) {
      final stopwatch = Stopwatch()
        ..start();
      var res = await _thumbnailRepository.findThumbnailByKeyWordAll(keyword);
      print('[Time] Query Search All executed in ${stopwatch.elapsed}');
      stopwatch.stop();
      return res;
    }else{
      var res = await _thumbnailRepository.findThumbnailByKeyWordAll(keyword);
      return res;
    }
  }
  getThumbnailsByKeyWord(String keyword) async{
    return await _thumbnailRepository.findThumbnailByKeyWord(keyword);
  }
  getThumbnails({String query}) async {
    if(DEBUG_MODE) {
      final stopwatch = Stopwatch()
        ..start();
      var result = await _thumbnailRepository.getAllThumbnails(query: query);
      print('[Time] Query Thumbnail executed in ${stopwatch.elapsed}');
      stopwatch.stop();
      return result;
    }else{
      var result = await _thumbnailRepository.getAllThumbnails(query: query);
      return result;
    }
  }
}