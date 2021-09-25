import 'package:clock365/constants.dart';
import 'package:clock365/models/clock_user.dart';
import 'package:clock365/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box(kUserBox).listenable(),
        builder: (context, Box userBox, child) {

          final String userId = userBox.get(kcurrentUserId);
          ClockUser currentUser = userBox.get(userId)["currentUser"];

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
                ProfileOptions(),
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
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('Present'),
                  SizedBox(
                    width: 16,
                  ),
                  CircleAvatar(
                    child: Text(
                      '8',
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
                  Text('Present'),
                  SizedBox(
                    width: 16,
                  ),
                  CircleAvatar(
                    child: Text(
                      '8',
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
  }
}

class ProfileOptions extends StatelessWidget {
  const ProfileOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text('Your Sites'),
          onTap: () {},
        ),
        Divider(),
        ListTile(
          title: Text('Your Staff'),
          onTap: () {},
        ),
      ],
    );
  }
}
