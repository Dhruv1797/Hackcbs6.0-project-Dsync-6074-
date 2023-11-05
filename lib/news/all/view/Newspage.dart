import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/api_http.dart';
import '../model/newsmodel.dart';
import '../provider/newsprovider.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({Key? key}) : super(key: key);

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  NewsProvider? newsProvidertrue;

  @override
  Widget build(BuildContext context) {
    newsProvidertrue = Provider.of(context, listen: true);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              height: 65,
              width: double.infinity,
              child: ListView.builder(
                itemCount: newsProvidertrue!.name.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(120, 30),
                              backgroundColor: Color(0xff636667)),
                          onPressed: () {
                            newsProvidertrue!.ChangeIndex(index);
                          },
                          child: Text(
                            "${newsProvidertrue!.name[index]}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: Apihttp().getNews(
                    "${newsProvidertrue!.name[newsProvidertrue!.index]}(top news)"),
                builder: (context, shapshot) {
                  if (shapshot.hasError) {
                    return Text("${shapshot.hasError}");
                  } else if (shapshot.hasData) {
                    NewsModal? l1 = shapshot.data;
                    return ListView.builder(
                      // scrollDirection: Axis.horizontal,
                      itemCount: l1!.articles!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 150,
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 50,
                                        width: 200,
                                        child: Text(
                                          "${l1.articles![index].title}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 50,
                                        width: 200,
                                        child: Text(
                                          "${l1.articles![index].description}",
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: Image.network(
                                  "${l1.articles![index].urlToImage}",
                                  height: double.infinity,
                                  width: 170,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
