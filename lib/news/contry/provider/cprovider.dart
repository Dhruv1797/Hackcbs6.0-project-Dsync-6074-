import 'package:flutter/material.dart';

class CountryProvider extends ChangeNotifier
{
  List country = [
    "india" ,
    "us",
    "china",
    "japan",
    "russia"
  ];
  int index2=0;
  void ChangeIndex2(newindex)
  {
    index2=newindex;
    notifyListeners();
  }
}