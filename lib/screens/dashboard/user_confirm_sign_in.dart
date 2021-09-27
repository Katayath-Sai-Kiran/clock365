import 'package:clock365/constants.dart';
import 'package:clock365/generated/l10n.dart';
import 'package:clock365/models/clock_user.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserConfirmSignInScreen extends StatefulWidget {
  const UserConfirmSignInScreen({Key? key}) : super(key: key);

  @override
  _UserConfirmSignInScreenState createState() =>
      _UserConfirmSignInScreenState();
}

class _UserConfirmSignInScreenState extends State<UserConfirmSignInScreen> {
  @override
  Widget build(BuildContext context) {
     Map selectedOrganization =
        ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).signInDetails),
      ),
      body: ValueListenableBuilder(
          valueListenable: Hive.box<dynamic>(kUserBox).listenable(),
          builder: (context, Box box, child) {
            String userId = box.get(kcurrentUserId);
            ClockUser currentUser = box.get(userId)["currentUser"];

            selectedOrganization["currentUser"] = currentUser;

            return SafeArea(
              child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentUser.name.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(currentUser.website.toString()),
                        ],
                      ),
                      Container(
                          alignment: Alignment.bottomCenter,
                          child: ElevatedButton(
                            onPressed: () => {
                              Navigator.of(context).pushNamed(
                                  kCapturePhotoScreen,
                                  arguments: selectedOrganization)
                            },
                            child: Text(
                              S.of(context).actionContinue,
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor),
                            ),
                          ))
                    ],
                  )),
            );
          }),
    );
  }
}
