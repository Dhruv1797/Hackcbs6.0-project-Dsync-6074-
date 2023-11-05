import 'package:flutter/material.dart';
import 'package:moveasyuserapp/widgets/bottonnavigationbar.dart';

class Navbarscreen extends StatefulWidget {
  const Navbarscreen({super.key});

  @override
  State<Navbarscreen> createState() => _NavbarscreenState();
}

class _NavbarscreenState extends State<Navbarscreen> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationwidget(),
    );
  }
}
