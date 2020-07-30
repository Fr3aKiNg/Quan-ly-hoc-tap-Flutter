import 'package:scheduleapp/utils/app_constant.dart';
import 'package:scheduleapp/utils/model/tag.dart';
import 'package:scheduleapp/utils/dao/tag_dao.dart';

class TagBUS {
  final _tagDao = TagDAO();

  ///Check tag Exist
  ///Required: Tag
  ///case tag exist return true;
  ///case tag not exist return false;
//  isTitleTagExist(String title) async {
//    if (DEBUG_MODE) {
//      final stopwatch = Stopwatch()..start();
//      var res = await _tagDao.(title);
//      print(
//          '[Time] Check Tag ${title} exists executed in ${stopwatch.elapsed}');
//      stopwatch.stop();
//      return res;
//    } else {
//      var res = await _tagDao.isTagExist(title);
//      return res;
//    }
//  }

  ///Get list tag
  ///Required: optional {query}
  ///case not found return []
  ///case found return List<Tag>
  getTags({String query}) async {
    if (DEBUG_MODE) {
      final stopwatch = Stopwatch()..start();
      var res = await _tagDao.getTags(query: query);
      print('[Time] Query All Tag executed in ${stopwatch.elapsed}');
      stopwatch.stop();
      return res;
    } else {
      var res = await _tagDao.getTags(query: query);
      return res;
    }
  }

  //Get Tag from database
  //Required tagId
  //case tag exist return tag
  //case tag not exist return null
  getTagById(String tagId) async {
    if (DEBUG_MODE) {
      final stopwatch = Stopwatch()..start();
      var res = await _tagDao.getTagByID(tagId);
      print('[Time] Query Tag by ID ${tagId} executed in ${stopwatch.elapsed}');
      stopwatch.stop();
      return res;
    } else {
      var res = await _tagDao.getTagByID(tagId);
      return res;
    }
  }

//Add Tag to database
//case exist tag won't add and return -1
//case non-exist tag will add and return tagId
  addTag(Tag tag) async {
    var res = false;
    if (DEBUG_MODE) {
      final stopwatch = Stopwatch()..start();
      await _tagDao.createTag(tag);
      print('[Time] Add new Tag ${tag.title} executed in ${stopwatch.elapsed}');
      stopwatch.stop();
    } else {
      await _tagDao.createTag(tag);
    }
    return true;
  }

  //Update Tag
  //Required: Tag
  updateTag(Tag tag) async {
    if (DEBUG_MODE) {
      final stopwatch = Stopwatch()..start();
      var res = await _tagDao.updateTag(tag);
      print('[Time] Update Tag ${tag.title} executed in ${stopwatch.elapsed}');
      stopwatch.stop();
      return res > 0;
    } else {
      var res = await _tagDao.updateTag(tag);
      return res > 0;
    }
  }

  deleteTagById(String tagId) async {
    if (DEBUG_MODE) {
      final stopwatch = Stopwatch()..start();
      var res = await _tagDao.deleteTag(tagId);
      print('[Time] Delete Tag ${tagId} executed in ${stopwatch.elapsed}');
      stopwatch.stop();
      return res > 0;
    } else {
      var res = await _tagDao.deleteTag(tagId);
      return res > 0;
    }
  }
}
