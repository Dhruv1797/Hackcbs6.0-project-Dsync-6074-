import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../all/model/newsmodel.dart';
import '../../utils/api_http.dart';
import '../provider/bprovider.dart';

class BusinessPage extends StatefulWidget {
  const BusinessPage({Key? key}) : super(key: key);

  @override
  State<BusinessPage> createState() => _BusinessPageState();
}

class _BusinessPageState extends State<BusinessPage> {
  BusinessProvider? BusinessProvidertrue;

  @override
  Widget build(BuildContext context) {
    BusinessProvidertrue = Provider.of(context, listen: true);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              height: 65,
              width: double.infinity,
              child: ListView.builder(
                itemCount: BusinessProvidertrue!.business.length,
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
                            BusinessProvidertrue!.ChangeIndex3(index);
                          },
                          child: Text(
                            "${BusinessProvidertrue!.business[index]}",
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
                    "${BusinessProvidertrue!.business[BusinessProvidertrue!.index4]}(Business)"),
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
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  height: double.infinity,
                                  width: 50,
                                  child: Image.network(
                                      "${l1.articles![index].urlToImage}"),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                      ],
                    ),
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
