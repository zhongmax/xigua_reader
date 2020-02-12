import 'package:flutter/src/widgets/framework.dart';
import 'package:xigua_read/base/structure/base_view_model.dart';
import 'package:xigua_read/model/novel/book_net.dart';

class NovelBookIntroViewModel extends BaseViewModel {
  NovelBookIntroViewModel(this._netBookModel);

  NovelBookNetModel _netBookModel;

  NovelBookIntroContentEntity get contentEntity =>
      _netBookModel.bookIntroContentEntity;

  void getNovelInfo(String bookId) {
    getDetailInfo(bookId);
    getNovelShortReview(bookId);
    getNovelBookReview(bookId);
    getNovelBookRecommend(bookId);
  }

  void getDetailInfo(String bookId) async {
    var result = await _netBookModel.getNovelDetailInfo(bookId);

    if (result.isSuccess && result?.data != null) {
      contentEntity.detailInfo = result.data;
      notifyListeners();
    }
  }

  void getNovelShortReview(String bookId) async {
    var result = await _netBookModel.getNovelShortReview(bookId, limit: 2);
    if (result.isSuccess && result?.data != null) {
      contentEntity.shortComment = result.data;
      notifyListeners();
    }
  }

  void getNovelBookReview(String bookId) async {
    var result = await _netBookModel.getNovelBookReview(bookId, limit: 2);
    if (result.isSuccess && result?.data != null) {
      contentEntity.bookReviewInfo = result.data;
      notifyListeners();
    }
  }

  void getNovelBookRecommend(String bookId) async {
    var result = await _netBookModel.getNovelBookRecommend(bookId);
    if (result.isSuccess && result?.data != null) {
      contentEntity.bookRecommendInfo = result.data;
      notifyListeners();
    }
  }

  @override
  Widget getProviderContainer() {
    return null;
  }
}
