import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wallpaperapp/pages/account_page.dart';
import 'package:wallpaperapp/pages/explore_page.dart';
import 'package:wallpaperapp/pages/favourite_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedPageIndex = 0;

  var _pages = [
    ExplorePage(),
    FavouritePage(),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.black12,
        items: [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.wpexplorer),
            title: Text("Explore")
          ),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.kissWinkHeart),
              title: Text("Favourites")
          ),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.personBooth),
              title: Text("Account")
          ),

        ],
        currentIndex: _selectedPageIndex,
        onTap: (index){
            setState(() {
              _selectedPageIndex = index;
            });
        },
      )
    );
  }
}
