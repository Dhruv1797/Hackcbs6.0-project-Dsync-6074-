import 'dart:convert';

import 'package:http/http.dart' as http;

import '../all/model/newsmodel.dart';

class Apihttp {
  String apilink2 =
      "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=92006f1c2bb1459c8240c92d567a50fa";

  Future<NewsModal?> getNews(String con) async {
    print(con);
    String apilink =
        "https://newsapi.org/v2/everything?q=$con&from=2023-06-29&to=2023-06-29&sortBy=popularity&apiKey=92006f1c2bb1459c8240c92d567a50fa";
    var response = await http.get(Uri.parse(apilink));
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return NewsModal.fromJson(json);
    }
    return null;
  }
}
