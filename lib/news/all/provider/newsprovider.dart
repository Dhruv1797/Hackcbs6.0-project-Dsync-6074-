import 'package:flutter/material.dart';

class NewsProvider extends ChangeNotifier
{
  List name = [
    "Microsoft" ,
    "Bollywood",
    "Youtube",
    "Hollywood",
    "Google",
    "Tata",
    "Meta"
  ];
  int index=0;
  void ChangeIndex(newindex)
  {
    index=newindex;
    notifyListeners();
  }
}