import 'package:flutter/material.dart';

class BusinessProvider extends ChangeNotifier
{
  List business = [
    "india",
    "us",
    "china",
    "korea",
    "sri lanka"
  ];
  int index4=0;
  void ChangeIndex3(newindex)
  {
    index4=newindex;
    notifyListeners();
  }
}