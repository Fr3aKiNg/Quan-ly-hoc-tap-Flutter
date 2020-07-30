import 'package:scheduleapp/utils/dao/tag_dao.dart';
import 'package:scheduleapp/utils/model/tag.dart';

class TagRepository {
  final tagDao = TagDAO();

  Future getAllTags({String query}) => tagDao.getTags(query: query);

  Future getTag(String id) => tagDao.getTagByID(id);
  Future isTagExist(String title) => tagDao.exist(title);

  Future insertTag(Tag tag) => tagDao.createTag(tag);
  Future updateTags(Tag tag) => tagDao.updateTag(tag);

  Future deleteTagById(String id) => tagDao.deleteTag(id);

  //We are not going to use this in the demo
  Future deleteAllTags() => tagDao.deleteAllTags();
}