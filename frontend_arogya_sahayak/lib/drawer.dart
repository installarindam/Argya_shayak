import 'package:flutter/material.dart';

import 'login_screen.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('User Name'),
            accountEmail: Text('user@example.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/images/person.jpg'),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              // Add navigation to settings screen here if needed
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              // Add navigation to profile screen here if needed
            },
          ),

          Divider(),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'For Hack-0-Med 2023\nby Team: Techno Therapeutics\nTeam Leader: Arindam Sarkar\ncontact: arindams.cse.jisu21@gmail.com\nJIS University',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                Container(
                  color: Colors.blue[400], // Change this to your desired color
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Logout'),
                    onTap: () {
                      Navigator.pop(context); // Close drawer
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
