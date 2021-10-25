import 'dart:ui';

import 'package:clock365/constants.dart';
import 'package:clock365/generated/l10n.dart';
import 'package:clock365/models/clock_user.dart';
import 'package:clock365/providers/organization_provider.dart';
import 'package:clock365/screens/qrTest.dart';

import 'package:clock365/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:clock365/models/OrganizationModel.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  int tabIndex = 0;
  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _tabController?.addListener(() {
      if (_tabController!.indexIsChanging) {
        setState(() {
          tabIndex = _tabController!.index;
        });
      }
    });
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
          return Consumer<OrganizationProvider>(
              builder: (context, OrganizationProvider organizationProvider, _) {
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
                                  style: themeData.textTheme.headline5
                                      ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              themeData.colorScheme.onSurface),
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
                                data: currentOrganization.organizationId
                                    .toString(),
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
                        controller: _tabController,
                        automaticIndicatorColorAdjustment: true,
                        unselectedLabelColor: Colors.white,
                        labelColor: Colors.white,
                        overlayColor:
                            MaterialStateProperty.all<Color>(Colors.white),
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
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      color: tabIndex == 0
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                              ),
                            ),
                          ),
                          Container(
                            height: Get.height * 0.06,
                            width: Get.width * 0.4,
                            child: Center(
                              child: Text(
                                "Visitors",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                        color: tabIndex == 1
                                            ? Colors.white
                                            : Colors.black87),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: Get.height * 0.45,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            CustomUserList(
                                type: 1,
                                organizationProvider: organizationProvider),
                            CustomUserList(
                                type: 2,
                                organizationProvider: organizationProvider),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}

class CustomUserList extends StatefulWidget {
  final int type;
  final OrganizationProvider organizationProvider;
  const CustomUserList(
      {Key? key, required this.type, required this.organizationProvider})
      : super(key: key);

  @override
  _CustomUserListState createState() => _CustomUserListState();
}

class _CustomUserListState extends State<CustomUserList> {
  @override
  Widget build(BuildContext context) {
    List<ClockUser> staff = [];
    List<ClockUser> visitors = [];
    return Consumer<OrganizationProvider>(
        builder: (context, OrganizationProvider organizationProvider, _) {
      if (widget.type == 1) {
        staff = organizationProvider.currentOrganizationSignedInStaff;
      } else {
        visitors = organizationProvider.currentOrganizationSignedInVisitors;
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 16,
          ),
          staff.length > 0
              ? RefreshIndicator(
                  displacement: 20.0,
                  color: Theme.of(context).colorScheme.primary,
                  triggerMode: RefreshIndicatorTriggerMode.anywhere,
                  onRefresh: () {
                    if (widget.type == 1) {
                      return Provider.of<OrganizationProvider>(context,
                              listen: false)
                          .getCurrentOrganizationSignedInStaff(
                              context: context);
                    } else {
                      return Provider.of<OrganizationProvider>(context,
                              listen: false)
                          .getCurrentOrganizationSignedInVisitors(
                              context: context);
                    }
                  },
                  child: Container(
                    height: Get.height * 0.4,
                    child: ListView.builder(
                      // physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          widget.type == 1 ? staff.length : visitors.length,
                      itemBuilder: (context, index) => StaffItem(
                        user: widget.type == 1 ? staff[index] : visitors[index],
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 48.0, right: 16.0),
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/no_users.svg",
                      height: Get.height * 0.2,
                      width: Get.width * 0.25,
                    ),
                  ),
                ),
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
