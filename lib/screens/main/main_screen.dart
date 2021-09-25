import 'package:clock365/constants.dart';
import 'package:clock365/models/destination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: Icon(Icons.menu),
      // ),
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: _selectedIndex,
          children: allDestinations.map<Widget>((Destination destination) {
            return destination.child ?? SizedBox();
          }).toList(),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BottomNavigationBar(
            backgroundColor: themeData.colorScheme.primary,
            selectedItemColor: themeData.scaffoldBackgroundColor,
            unselectedItemColor:
                themeData.scaffoldBackgroundColor.withOpacity(.75),
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: allDestinations
                .map(
                  (Destination destination) => BottomNavigationBarItem(
                    icon: SizedBox(
                      height: 24,
                      width: 24,
                      child: SvgPicture.asset(
                        destination.iconPath,
                      ),
                    ),
                    label: destination.name,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
