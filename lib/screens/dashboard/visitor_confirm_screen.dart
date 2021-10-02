import 'package:clock365/constants.dart';
import 'package:clock365/generated/l10n.dart';
import 'package:clock365/models/clock_user.dart';
import 'package:clock365/screens/dashboard/captureV_visitor_photo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:clock365/models/OrganizationModel.dart';

class VisitorSignInConfirm extends StatelessWidget {
  final OrganizationModel? selectedOrganization;

  VisitorSignInConfirm({required this.selectedOrganization});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).signInDetails),
      ),
      body: ValueListenableBuilder(
          valueListenable: Hive.box<dynamic>(kUserBox).listenable(),
          builder: (context, Box box, child) {
            ClockUser currentUser = box.get(kCurrentUserKey);

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
                            onPressed: () {
                              Get.to(() => CaptureVisitorPhoto(
                                    selectedOrganization: selectedOrganization,
                                  ));
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
