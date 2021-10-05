import 'package:clock365/providers/user_provider.dart';
import 'package:flutter/material.dart';

import 'package:clock365/constants.dart';
import 'package:clock365/models/clock_user.dart';
import 'package:clock365/repository/organization_repository.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:clock365/models/OrganizationModel.dart';

class OrganizationDetails extends StatelessWidget {
  const OrganizationDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ClockUserProvider organizationRepository =
        Provider.of<ClockUserProvider>(context, listen: false);
    final ClockUser currentUser = Hive.box(kUserBox).get(kCurrentUserKey);

    //organizationRepository.getCurrentUserSites();

    return Scaffold(
      appBar: AppBar(
        title: Text("Organizations"),
      ),
      body: ListView.builder(
        padding: EdgeInsets.only(
            bottom: Get.height * 0.05, left: 16.0, right: 16.0, top: 12.0),
        itemCount: organizationRepository.currentUserOrganizations?.length,
        itemBuilder: (_, int index) {
          return StaffItem(
              organization:
                  organizationRepository.currentUserOrganizations![index]);
        },
      ),
    );
  }
}

class StaffItem extends StatelessWidget {
  final OrganizationModel organization;
  const StaffItem({required this.organization});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.08,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 1.5,
          color: Color(
            int.parse(
              organization.colorCode.toString(),
            ),
          ).withOpacity(double.parse(organization.colorOpacity.toString())),
        ),
      ),
      margin: EdgeInsets.only(top: 8),
      child: TextButton(
        onPressed: () => {},
        child: Text(organization.organizationName.toString(),
            style: Theme.of(context).textTheme.subtitle2),
      ),
    );
  }
}
