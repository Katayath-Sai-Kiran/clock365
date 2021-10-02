import 'package:clock365/constants.dart';
import 'package:clock365/generated/l10n.dart';
import 'package:clock365/models/clock_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';

class ReadySetGoScreen extends StatefulWidget {
  ReadySetGoScreen({Key? key}) : super(key: key);

  @override
  State<ReadySetGoScreen> createState() => _ReadySetGoScreenState();
}

class _ReadySetGoScreenState extends State<ReadySetGoScreen> {
  bool guidedAccess = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).readySetGo),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              S.of(context).tipsText,
              style: themeData.textTheme.headline5?.copyWith(
                  color: themeData.colorScheme.primary,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 16,
            ),
            Flexible(
                child: Text(
              S.of(context).protectHomeButtonWithPin,
              style: themeData.textTheme.subtitle1
                  ?.copyWith(fontWeight: FontWeight.bold),
            )),
            Padding(
                padding: EdgeInsets.only(top: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SvgPicture.asset(
                        'assets/pin_illustration.svg',
                        height: 176,
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                            text: TextSpan(
                                text:
                                    S.of(context).protectHomeButtonWithPinDesc,
                                style: themeData.textTheme.bodyText2,
                                children: <TextSpan>[
                              TextSpan(
                                text:
                                    '\n${S.of(context).guidedAccessIsCurrently}',
                                style: themeData.textTheme.subtitle2,
                              ),
                            ])),
                        CupertinoSwitch(
                            value: guidedAccess,
                            thumbColor: themeData.primaryColor,
                            activeColor: themeData.secondaryHeaderColor,
                            onChanged: (newState) {
                              setState(() {
                                guidedAccess = newState;
                              });
                            })
                      ],
                    ))
                  ],
                )),
            SizedBox(
              height: 32,
            ),
            Flexible(
                child: Text(
              S.of(context).visitTheDashboard,
              style: themeData.textTheme.subtitle1
                  ?.copyWith(fontWeight: FontWeight.bold),
            )),
            Padding(
                padding: EdgeInsets.only(top: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            S.of(context).visitTheDashboardDesc,
                            style: themeData.textTheme.bodyText2,
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: SvgPicture.asset(
                            'assets/dashboard_illustration.svg',
                            height: 144,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Flexible(
                      child: Text(
                        S.of(context).visitTheDashboardDesc2,
                        style: themeData.textTheme.bodyText2,
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: 32,
            ),
            Flexible(
                child: Text(
              S.of(context).enclosureForIpads,
              style: themeData.textTheme.subtitle1
                  ?.copyWith(fontWeight: FontWeight.bold),
            )),
            Padding(
                padding: EdgeInsets.only(top: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SvgPicture.asset(
                        'assets/enclosure_for_ipads_illustration.svg',
                        height: 176,
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Text(
                        S.of(context).enclosureForIpadsDesc,
                        style: themeData.textTheme.bodyText2,
                      ),
                    )
                  ],
                )),
            SizedBox(
              height: 32,
            ),
            ElevatedButton(
              onPressed: () async {
                await Hive.box(kUserBox).put("isLoggedIn", true);


                Navigator.of(context)
                    .pushNamedAndRemoveUntil(kMainScreen, (route) => false);
              },
              child: Text(S.of(context).actionContinue),
            )
          ],
        ),
      ),
    );
  }
}
