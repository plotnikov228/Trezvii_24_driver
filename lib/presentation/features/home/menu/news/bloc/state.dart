import 'package:trezvii_24_driver/domain/firebase/news/models/news_model.dart';

import '../../../../../utils/status_enum.dart';

class NewsState {
  final List<NewsModel> news;
  final Status status;

  NewsState({this.status = Status.Success, this.news = const[]});
}