import 'package:clock365/constants.dart';
import 'package:clock365/models/clock_user.dart';
import 'package:clock365/repository/organization_repository.dart';
import 'package:clock365/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:clock365/constants.dart';

class StaffDetails extends StatelessWidget {
  const StaffDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrganizationRepository organizationRepository =
        Provider.of(context, listen: false);
    final ClockUser currentUser = Hive.box(kUserBox).get(kCurrentUserKey);

    return Scaffold(
      appBar: AppBar(
        title: Text("Staff"),
      ),
      body: FutureBuilder(
          future: organizationRepository.getCurrentOrganizationStaff(
              organizationId:
                  currentUser.currentOrganization!.organizationId.toString(),
              context: context),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final List<ClockUser> staff = snapshot.data;
            return Container(
              padding: EdgeInsets.all(16.0),
              height: Get.height,
              width: Get.width,
              child: ListView.builder(
                itemCount: staff.length,
                itemBuilder: (_, int index) {
                  return StaffItem(user: staff[index]);
                },
              ),
            );
          }),
    );
  }
}

class StaffItem extends StatelessWidget {
  final ClockUser user;
  const StaffItem({required this.user});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 2, color: kStrokeColor)),
      margin: EdgeInsets.only(top: 8),
      child: TextButton(
          onPressed: () => {},
          child: Row(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    'assets/sample_capture.png',
                    width: 48,
                    height: 48,
                  )),
              SizedBox(
                width: 16,
              ),
              Expanded(
                  child: Text(user.name.toString(),
                      style: Theme.of(context).textTheme.subtitle2))
            ],
          )),
    );
  }
}
