import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:my_app/pages/Stadistic.dart';
import 'package:my_app/pages/calendar.dart';
import 'package:my_app/pages/recipeList.dart';

class MyMenu extends StatefulWidget {
  final String cadena;
  const MyMenu(this.cadena, {Key? key}) : super(key: key);
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<MyMenu> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      RecipeList(widget.cadena),
      Calendar(),
      HomePageSars(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.amber[300]!,
              hoverColor: Colors.amber[100]!,
              gap: 8,
              activeColor: Colors.amber[900],
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.amber[100]!,
              color: Colors.black,
              tabs: [
                GButton(
                    icon: LineIcons.utensils,
                    iconColor: Colors.amber[800],
                    text: 'Home',
                    textStyle: TextStyle(color: Colors.amber[400])),
                GButton(
                    icon: LineIcons.calendar,
                    iconColor: Colors.amber[800],
                    text: 'Likes',
                    textStyle: TextStyle(color: Colors.amber[400])),
                GButton(
                    icon: LineIcons.barChart,
                    iconColor: Colors.amber[800],
                    text: 'Search',
                    textStyle: TextStyle(color: Colors.amber[400]))
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
