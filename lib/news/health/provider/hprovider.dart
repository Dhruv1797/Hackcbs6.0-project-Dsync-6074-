import 'package:flutter/material.dart';

class HelthProvider extends ChangeNotifier
{
  List helth = [
    "india",
    "us",
    "cn",
    "korea",
    "japan"
  ];
  int index3=0;
  void ChangeIndex3(newindex)
  {
    index3=newindex;
    notifyListeners();
  }
}