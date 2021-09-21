import 'package:clock365/generated/l10n.dart';
import 'package:clock365/models/clock_user.dart';
import 'package:clock365/providers/clock_user_provider.dart';
import 'package:clock365/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).dashboardTitle),
        ),
        body: SafeArea(
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
                        S.of(context).onSiteAtX('DLF Saket'),
                        style: themeData.textTheme.headline5?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: themeData.colorScheme.onSurface),
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: TextButton(
                              onPressed: null,
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
                                  )
                                ],
                              )))
                    ],
                  )),
                  Expanded(
                      child: FittedBox(child: Icon(Icons.qr_code_2_rounded)))
                ],
              ),
              Divider(
                thickness: 2,
              ),
              StaffList(),
              // Center(
              //     child: SvgPicture.asset('assets/no_one_here.svg',
              //         height: 144, width: 144))
            ],
          ),
        )));
  }
}

class StaffList extends StatefulWidget {
  const StaffList({Key? key}) : super(key: key);

  @override
  _StaffListState createState() => _StaffListState();
}

class _StaffListState extends State<StaffList> {
  @override
  Widget build(BuildContext context) {
    final ClockUserProvider clockUserProvider =
        Provider.of(context, listen: false);
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
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: clockUserProvider.staff.length,
            itemBuilder: (context, index) => StaffItem(
                  user: clockUserProvider.staff[index],
                ))
      ],
    );
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
