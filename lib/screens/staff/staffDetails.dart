import 'package:clock365/models/clock_user.dart';
import 'package:clock365/providers/organization_provider.dart';
import 'package:clock365/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class StaffDetails extends StatelessWidget {
  const StaffDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrganizationProvider organizationRepository =
        Provider.of<OrganizationProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Staff"),
      ),
      body: Container(
              padding: EdgeInsets.all(16.0),
              height: Get.height,
              width: Get.width,
              child: ListView.builder(
                itemCount:
              organizationRepository.currentOrganizationStaff.length,
                itemBuilder: (_, int index) {
                  return StaffItem(
                user: organizationRepository
                    .currentOrganizationStaff[index]);
                },
              ),
      ),
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
