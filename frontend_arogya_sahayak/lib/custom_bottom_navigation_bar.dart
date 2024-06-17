// custom_bottom_app_bar.dart
import 'package:ArogyaSahayak/profile.dart';
import 'package:flutter/material.dart';

import 'chat.dart';
import 'history.dart';

class CustomBottomAppBar extends StatelessWidget {
  final Function(int) onTabSelected;
  final int selectedIndex;

  CustomBottomAppBar({required this.onTabSelected, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 4.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () => onTabSelected(0),
            color: selectedIndex == 0 ? Colors.blue : Colors.grey,
          ),
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: () {
              onTabSelected(1);
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
            },
            color: selectedIndex == 1 ? Colors.blue : Colors.grey,
          ),
          SizedBox(width: 50),  // Creating space for the floating action button
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              onTabSelected(2);
              Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryPage()));
            },
            color: selectedIndex == 2 ? Colors.blue : Colors.grey,
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              onTabSelected(3);
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
            },
            color: selectedIndex == 3 ? Colors.blue : Colors.grey,
          ),
        ],
      ),
    );
  }
}
