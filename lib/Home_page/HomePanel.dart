import 'package:flutter/material.dart';
import 'package:flutter_application_1/Home_page/Assignment.dart';
import 'package:flutter_application_1/Home_page/Querry.dart';
import 'package:flutter_application_1/Home_page/profile.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';



class HomeDash extends StatefulWidget {
  const HomeDash({Key? key}) : super(key: key);

  @override
  State<HomeDash> createState() => _HomeDashState();
}
class _HomeDashState extends State<HomeDash> {
  final controller = PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreen() {
    return [
      Assignment(),
      Query(), 
      Profile(),
     
    ];
  }


  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
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
      screens: _buildScreen(),
      items: _navBarItems(),
      backgroundColor: Colors.grey[200]!, 
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(1),
      ),
    );

    
  }
}

