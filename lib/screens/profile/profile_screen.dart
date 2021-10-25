import 'package:clock365/constants.dart';
import 'package:clock365/models/clock_user.dart';
import 'package:clock365/providers/organization_provider.dart';
import 'package:clock365/providers/user_provider.dart';
import 'package:clock365/screens/staff/staffDetails.dart';
import 'package:clock365/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:clock365/screens/organizations/organizationDetails.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    Provider.of<ClockUserProvider>(context, listen: false)
        .getUserAttendenceData(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box(kUserBox).listenable(),
        builder: (context, Box userBox, child) {
          ClockUser currentUser = userBox.get(kCurrentUserKey);

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
              ],
            ),
          );
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
  const ProfileStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OrganizationProvider>(
        builder: (context, OrganizationProvider organizationProvider, _) {
      final int presentStaff =
          organizationProvider.currentOrganizationSignedInStaff.length;
      final int staffAbsent =
          organizationProvider.currentOrganizationStaff.length - presentStaff;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
      Divider(
        height: 2.0,
      ),
      ListTile(
        title: Text('Your Staff'),
        onTap: () => Get.to(() => StaffDetails()),
      ),
    ]));
  }
}
