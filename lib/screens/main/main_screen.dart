import 'package:clock365/constants.dart';
import 'package:clock365/models/destination.dart';
import 'package:clock365/providers/organization_provider.dart';
import 'package:clock365/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      
      Provider.of<OrganizationProvider>(context, listen: false)
          .updateOrganizationLoadingStatus(updatedState: true);
      Provider.of<OrganizationProvider>(context, listen: false)
          .getCurrentOrganizationSignedInVisitors(context: context);
      Provider.of<OrganizationProvider>(context, listen: false)
          .getCurrentOrganizationSignedInStaff(context: context);
      Provider.of<ClockUserProvider>(context, listen: false)
          .getCurrentUserSites(context: context);
      Provider.of<OrganizationProvider>(context, listen: false)
          .getCurrentOrganizationStaff(context: context);

      Provider.of<OrganizationProvider>(context, listen: false)
          .updateOrganizationLoadingStatus(updatedState: false);
    });
    super.initState();
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: _selectedIndex,
          children: allDestinations.map<Widget>((Destination destination) {
            return destination.child ?? SizedBox();
          }).toList(),
        ),
      ),
      bottomNavigationBar: Container(
        height: Get.height * 0.08,
        width: Get.width * 0.8,
        margin: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          fit: StackFit.loose,
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 8.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/user_profile.svg',
                        fit: BoxFit.cover,
                        height: 22.0,
                      ),
                      Text(
                        "User Profile",
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 8.0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      "assets/dashboard.svg",
                      height: 56.0,
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      "Settings",
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 8.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 2;
                    });
                  },
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        "assets/sign_in_out.svg",
                        height: 22.0,
                      ),
                      Text(
                        "Sign in/out",
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Padding(
  //       padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.circular(12),
  //         child: BottomNavigationBar(
  //           backgroundColor: themeData.colorScheme.primary,
  //           selectedItemColor: themeData.scaffoldBackgroundColor,
  //           unselectedItemColor:
  //               themeData.scaffoldBackgroundColor.withOpacity(.75),
  //           currentIndex: _selectedIndex,
  //           onTap: (index) {
  //             setState(() {
  //               _selectedIndex = index;
  //             });
  //           },
  //           items: allDestinations
  //               .map(
  //                 (Destination destination) => BottomNavigationBarItem(
  //                   icon: SizedBox(
  //                     height: 24,
  //                     width: 24,
  //                     child: SvgPicture.asset(
  //                       destination.iconPath,
  //                     ),
  //                   ),
  //                   label: destination.name,
  //                 ),
  //               )
  //               .toList(),
  //         ),
  //       ),
  //     ),
}
