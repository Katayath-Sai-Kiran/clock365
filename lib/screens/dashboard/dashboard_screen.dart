import 'dart:ui';

import 'package:clock365/constants.dart';
import 'package:clock365/generated/l10n.dart';
import 'package:clock365/models/clock_user.dart';
import 'package:clock365/repository/organization_repository.dart';
import 'package:clock365/screens/qrTest.dart';

import 'package:clock365/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:clock365/models/OrganizationModel.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  TabController? _tabController;
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
          ClockUser currentUser = userBox.get(kCurrentUserKey);
          OrganizationModel? currentOrganization =
              currentUser.currentOrganization;
          return DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: SafeArea(
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
                                S.of(context).onSiteAtX(currentOrganization!
                                    .organizationName
                                    .toString()),
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
                              data:
                                  currentOrganization.organizationId.toString(),
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
                    TabBar(
                      automaticIndicatorColorAdjustment: true,
                      unselectedLabelColor: Colors.white,
                      enableFeedback: false,
                      isScrollable: true,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      tabs: [
                        Container(
                          height: Get.height * 0.06,
                          width: Get.width * 0.4,
                          child: Center(
                            child: Text(
                              "Staff",
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                        ),
                        Container(
                          height: Get.height * 0.06,
                          width: Get.width * 0.4,
                          child: Center(
                            child: Text(
                              "Visitors",
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: Get.height * 0.45,
                      child: TabBarView(
                        children: [
                          StaffList(),
                          VisitorList(),
                        ],
                      ),
                    ),

                    //StaffList(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class StaffList extends StatefulWidget {
  const StaffList({
    Key? key,
  }) : super(key: key);

  @override
  _StaffListState createState() => _StaffListState();
}

class _StaffListState extends State<StaffList> {
  @override
  Widget build(BuildContext context) {
    ClockUser currentUser = Hive.box(kUserBox).get(kCurrentUserKey);
    final OrganizationRepository organizationRepository =
        Provider.of<OrganizationRepository>(context, listen: false);

    return FutureBuilder(
        future: organizationRepository.getCurrentOrganizationsignedStaff(
            organizationId:
                currentUser.currentOrganization!.organizationId.toString(),
            context: context),
        builder: (context, AsyncSnapshot snapshot) {
          bool isLoading = snapshot.connectionState == ConnectionState.waiting;
          final List<ClockUser> staff = snapshot.data ?? [];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 16,
              ),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: staff.length,
                      itemBuilder: (context, index) => StaffItem(
                        user: staff[index],
                      ),
                    )
            ],
          );
        });
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

class VisitorList extends StatefulWidget {
  const VisitorList({
    Key? key,
  }) : super(key: key);

  @override
  _VisitorListState createState() => _VisitorListState();
}

class _VisitorListState extends State<VisitorList> {
  @override
  Widget build(BuildContext context) {
    ClockUser currentUser = Hive.box(kUserBox).get(kCurrentUserKey);
    final OrganizationRepository organizationRepository =
        Provider.of<OrganizationRepository>(context, listen: false);

    return FutureBuilder(
        future: organizationRepository.getCurrentOrganizationsignedVisitors(
            organizationId:
                currentUser.currentOrganization!.organizationId.toString(),
            context: context),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final List<ClockUser> visitors = snapshot.data ?? [];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 16,
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: visitors.length,
                itemBuilder: (context, index) => VisitorItem(
                  visitor: visitors[index],
                ),
              )
            ],
          );
        });
  }
}

class VisitorItem extends StatelessWidget {
  final ClockUser visitor;

  VisitorItem({required this.visitor});
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
                  child: Text(visitor.name.toString(),
                      style: Theme.of(context).textTheme.subtitle2))
            ],
          )),
    );
  }
}
