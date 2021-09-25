import 'package:clock365/constants.dart';
import 'package:clock365/models/clock_user.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProfileDetailScreen extends StatelessWidget {
  const ProfileDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ClockUser user = ModalRoute.of(context)!.settings.arguments as ClockUser;
    return Scaffold(
        appBar: AppBar(
          title: Text(user.name.toString()),
        ),
        body: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/sample_capture.png', height: 192, width: 192),
              SizedBox(
                height: 16,
              ),
              Text(
                user.name.toString(),
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                user.email.toString(),
                style: Theme.of(context).textTheme.bodyText2,
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                user.website.toString(),
                style: Theme.of(context).textTheme.headline6,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 48),
                  child: ElevatedButton(
                      onPressed: () async {
                        String userId = Hive.box(kUserBox).get(kcurrentUserId);
                        Map userData = Hive.box(kUserBox).get(userId);
                        userData.update(
                            "loginDetails",
                          (value) => {"isLoggedIn": false},
                        );
                        await Hive.box(kUserBox).put(userId, userData);
                        await Hive.box(kUserBox).put(kcurrentUserId, null);

                        Navigator.of(context).pushNamedAndRemoveUntil(
                            kLoginRoute, (route) => false);
                      },
                      child: Text('Sign Out')))
            ],
          ),
        ));
  }
}
