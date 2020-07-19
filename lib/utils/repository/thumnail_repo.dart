import 'dart:wasm';

import 'package:Educare/utils/dao/thumbnail_dao.dart';
import 'package:Educare/utils/model/thumbnailNote.dart';

class ThumbnailRepository {
  final thumbnailDao = ThumbnailNoteDAO();

  Future findThumbnailByKeyWord(String keyword) => thumbnailDao.findThumbnailByKeyWord(keyword);
  Future findThumbnailByKeyWordAll(String keyword) => thumbnailDao.findThumbnailByKeyWordAll(keyword);
  Future findThumbnailByTagId(String tagId) => thumbnailDao.findThumbnailByTagId(tagId);

  Future getAllThumbnails({String query}) => thumbnailDao.getThumbnails(query: query);

  Future getThumbnail(String id) => thumbnailDao.getThumbnailByID(id);

  Future insertThumbnail(ThumbnailNote thumbnail) => thumbnailDao.createThumbnail(thumbnail);
  Future updateThumbnail(ThumbnailNote thumbnail) => thumbnailDao.updateThumbnail(thumbnail);

  Future deleteThumbnailById(String id) => thumbnailDao.deleteThumbnail(id);

  //We are not going to use this in the demo
  Future deleteAllThumbnails() => thumbnailDao.deleteAllThumbnails();
}