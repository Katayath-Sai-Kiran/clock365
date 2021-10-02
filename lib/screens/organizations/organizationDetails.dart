import 'package:flutter/material.dart';

import 'package:clock365/constants.dart';
import 'package:clock365/models/clock_user.dart';
import 'package:clock365/repository/organization_repository.dart';
import 'package:clock365/theme/colors.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:clock365/models/OrganizationModel.dart';

class OrganizationDetails extends StatelessWidget {
  const OrganizationDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrganizationRepository organizationRepository =
        Provider.of(context, listen: false);
    final ClockUser currentUser = Hive.box(kUserBox).get(kCurrentUserKey);

    return Scaffold(
      appBar: AppBar(
        title: Text("Organizations"),
      ),
      body: FutureBuilder(
          future: organizationRepository.getCurrentOrganizations(
              userId: currentUser.id.toString(), context: context),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final List<OrganizationModel> organizations = snapshot.data ?? [];
            return ListView.builder(
              padding: EdgeInsets.only(
                  bottom: Get.height * 0.05,
                  left: 16.0,
                  right: 16.0,
                  top: 12.0),
              itemCount: organizations.length,
              itemBuilder: (_, int index) {
                return StaffItem(organization: organizations[index]);
              },
            );
          }),
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
