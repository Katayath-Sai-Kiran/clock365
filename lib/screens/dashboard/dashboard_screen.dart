import 'dart:ui';

import 'package:clock365/constants.dart';
import 'package:clock365/generated/l10n.dart';
import 'package:clock365/models/clock_user.dart';
import 'package:clock365/screens/qrTest.dart';

import 'package:clock365/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:qr_flutter/qr_flutter.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // ClockUserProvider clockUserProvider = Provider.of(context, listen: false);
    // await clockUserProvider.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(S.of(context).dashboardTitle),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<dynamic>(kUserBox).listenable(),
        builder: (context, Box userBox, child) {
          String? userId = userBox.get(kcurrentUserId);
          final Map organization =
              userBox.get(userId)["currentOrganization"] ?? {};
          print(organization);
          final List staff = organization["staff_signed_in"] ?? [];
          final String organizationId = organization["_id"]["\$oid"] ?? "";
          final String organizationName = organization["name"] ?? "";

          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 24,
                            ),
                            Text(
                              S.of(context).onSiteAtX(organizationName),
                              style: themeData.textTheme.headline5?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: themeData.colorScheme.onSurface),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: TextButton(
                                onPressed: () async {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (_) {
                                    return QRViewExample();
                                  }));
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(S.of(context).touchless,
                                        style: themeData.textTheme.button),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      color: themeData.colorScheme.primary,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: FittedBox(
                          child: QrImage(
                            data: organizationId,
                            version: QrVersions.auto,
                            size: 150.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  StaffList(staff: staff),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class StaffList extends StatefulWidget {
  final List staff;
  const StaffList({Key? key, required this.staff}) : super(key: key);

  @override
  _StaffListState createState() => _StaffListState();
}

class _StaffListState extends State<StaffList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 16,
        ),
        Text(
          S.of(context).staff,
          style: Theme.of(context).textTheme.headline6?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold),
        ),
        RefreshIndicator(
          onRefresh: getStaff,
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.staff.length,
            itemBuilder: (context, index) => StaffItem(
              user: widget.staff[index],
            ),
          ),
        )
      ],
    );
  }

  Future getStaff() async {
    try {} catch (e) {}
  }
}

class StaffItem extends StatefulWidget {
  final ClockUser user;
  const StaffItem({Key? key, required this.user}) : super(key: key);

  @override
  _StaffItemState createState() => _StaffItemState();
}

class _StaffItemState extends State<StaffItem> {
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
                  child: Text(widget.user.name.toString(),
                      style: Theme.of(context).textTheme.subtitle2))
            ],
          )),
    );
  }
}
