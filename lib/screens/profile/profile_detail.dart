import 'package:clock365/customWidgets.dart';
import 'package:clock365/models/clock_user.dart';
import 'package:flutter/material.dart';

class ProfileDetailScreen extends StatelessWidget {
  ProfileDetailScreen({Key? key}) : super(key: key);

  final CustomWidgets _customWidgets = CustomWidgets();

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
                        _customWidgets.snacbarWithTwoButtons(context: context);
                       
                      },
                      child: Text('Sign Out')))
            ],
          ),
        ));
  }
}
