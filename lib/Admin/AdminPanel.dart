import 'package:flutter/material.dart';
import 'package:flutter_application_1/Admin/AdminHome.dart';
import 'package:flutter_application_1/Admin/Tquery.dart';

import 'package:flutter_application_1/Admin/aProfie.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'TaskAsi.dart';


class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final controller = PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      AdminDash(),
     TaskAsi(),
      Tquery(),
      AProfile(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
       PersistentBottomNavBarItem(icon: Icon(Icons.home)),
      PersistentBottomNavBarItem(icon: Icon(Icons.assignment)),
      PersistentBottomNavBarItem(icon: Icon(Icons.question_answer)),
      PersistentBottomNavBarItem(icon: Icon(Icons.account_circle)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: controller,
      screens: _buildScreens(),
      items: _navBarItems(),
      backgroundColor: Colors.grey[200]!,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}
