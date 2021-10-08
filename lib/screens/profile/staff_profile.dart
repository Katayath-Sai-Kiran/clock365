import 'package:clock365/constants.dart';
import 'package:clock365/customWidgets.dart';
import 'package:clock365/models/clock_user.dart';
import 'package:clock365/providers/user_provider.dart';
import 'package:clock365/screens/qrTest.dart';
import 'package:clock365/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:clock365/screens/organizations/organizationDetails.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StaffProfile extends StatefulWidget {
  const StaffProfile({Key? key}) : super(key: key);

  @override
  State<StaffProfile> createState() => _StaffProfileState();
}

class _StaffProfileState extends State<StaffProfile> {
  final CustomWidgets _customWidgets = CustomWidgets();

  @override
  void initState() {
    super.initState();

    Provider.of<ClockUserProvider>(context, listen: false)
        .getUserAttendenceData(context: context);
    Provider.of<ClockUserProvider>(context, listen: false)
        .getCurrentUserSites(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final double _height = Get.height;
    return ValueListenableBuilder(
        valueListenable: Hive.box(kUserBox).listenable(),
        builder: (context, Box userBox, child) {
          ClockUser currentUser = userBox.get(kCurrentUserKey);

          return Consumer<ClockUserProvider>(
              builder: (context, ClockUserProvider clockUserProvider, _) {
            return Scaffold(
              appBar: AppBar(
                title: Text(currentUser.name.toString()),
              ),
              body: ListView(
                children: [
                  ProfileHeader(
                    currentUser: currentUser,
                  ),
                  ProfileStatus(),
                  ProfileOptions(
                    currentUser: currentUser,
                  ),
                  SizedBox(
                    height: _height * 0.4,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).colorScheme.primary),
                      ),
                      onPressed: () {
                        Get.to(() => QRViewExample());
                      },
                      child: Text("SCAN QR"),
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }
}

class ProfileHeader extends StatelessWidget {
  final ClockUser currentUser;
  const ProfileHeader({Key? key, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          kProfileDetailRoute,
          arguments: currentUser,
        );
      },
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Image.asset(
              'assets/sample_capture.png',
              height: 72,
              width: 72,
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(currentUser.name.toString(),
                      style: Theme.of(context).textTheme.headline6),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    currentUser.email.toString(),
                    style: Theme.of(context).textTheme.caption,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    currentUser.website.toString(),
                    style: Theme.of(context).textTheme.subtitle2,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProfileStatus extends StatelessWidget {
  ProfileStatus({Key? key}) : super(key: key);
  List<String> weekdays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  int getSundays() {
    for (int i = 0; i <= 2; i++) {
      weekdays += weekdays;
    }
    int count = 0;
    String todayDay = DateFormat('EEEE').format(DateTime.now());
    int index = weekdays.indexOf(todayDay);

    int today = DateTime.now().day;
    List currentMonth = weekdays.sublist(today - index).sublist(0, today);
    currentMonth.forEach((element) {
      if (element == "Sunday") {
        count++;
      }
    });

    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ClockUserProvider>(
        builder: (context, ClockUserProvider clockUserProvider, _) {
      final int presentStaff = clockUserProvider.attendencePresentDays;
      final int staffAbsent =
          DateTime.now().day - (getSundays() + presentStaff);
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Row(
          children: [
            Expanded(
              child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: kStrokeColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Present'),
                        SizedBox(
                          width: 16,
                        ),
                        CircleAvatar(
                          child: Text(
                            presentStaff.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                ?.copyWith(color: Colors.white),
                          ),
                          backgroundColor: Colors.green,
                          radius: 12,
                        ),
                      ])),
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: kStrokeColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Absent'),
                    SizedBox(
                      width: 16,
                    ),
                    CircleAvatar(
                      child: Text(
                        staffAbsent.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            ?.copyWith(color: Colors.white),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      radius: 12,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class ProfileOptions extends StatelessWidget {
  final ClockUser currentUser;
  const ProfileOptions({Key? key, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: [
      ListTile(
        title: Text('Your Sites'),
        onTap: () => Get.to(() => OrganizationDetails()),
      ),
    ]));
  }
}
