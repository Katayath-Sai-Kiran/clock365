import 'package:clock365/constants.dart';
import 'package:clock365/generated/l10n.dart';
import 'package:clock365/models/clock_user.dart';
import 'package:clock365/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class EditStaffScreen extends StatefulWidget {
  const EditStaffScreen({Key? key}) : super(key: key);

  @override
  _EditStaffScreenState createState() => _EditStaffScreenState();
}

class _EditStaffScreenState extends State<EditStaffScreen> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).pageEditStaff),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).pageEditAddNewStaffMembers,
                  style: themeData.textTheme.headline5
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 16,
                ),
                TypeAheadField(
                    suggestionsCallback: (pattern) => <ClockUser>[
                          ClockUser(name: 'Test 1'),
                          ClockUser(name: 'Test 2'),
                          ClockUser(name: 'Test 3')
                        ],
                    itemBuilder: (BuildContext context, ClockUser clockUser) =>
                        MemberItem(clockUser: clockUser, isAdd: true),
                    onSuggestionSelected: (ClockUser clockUser) => {}),
                SizedBox(
                  height: 32,
                ),
                Text(
                  S.of(context).pageEditAddedMembers,
                  style: themeData.textTheme.headline6
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 16,
                ),
                Flexible(
                    child: ListView.builder(
                        itemCount: 30,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => MemberItem(
                            clockUser: ClockUser(name: 'Tester'),
                            isAdd: false))),
                SizedBox(
                  height: 32,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(kReadySetGoScreen);
                  },
                  child: Text(S.of(context).actionContinue),
                )
              ],
            ),
          ),
        ));
  }
}

class MemberItem extends StatefulWidget {
  final ClockUser clockUser;
  final bool isAdd;
  const MemberItem({Key? key, required this.clockUser, required this.isAdd})
      : super(key: key);

  @override
  _MemberItemState createState() => _MemberItemState();
}

class _MemberItemState extends State<MemberItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.isAdd ? EdgeInsets.zero : EdgeInsets.only(top: 8),
      padding: EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.isAdd ? 0 : 8),
          border: Border.all(
            width: widget.isAdd ? 0 : 1,
            color: kStrokeColor,
          )),
      child: Row(
        children: [
          Expanded(
              child: Text(
            widget.clockUser.name ?? '',
            style: Theme.of(context).textTheme.bodyText1,
          )),
          SizedBox(
            width: 16,
          ),
          IconButton(
              onPressed: () => {},
              icon: SizedBox(
                  height: 24,
                  width: 24,
                  child: SvgPicture.asset(!widget.isAdd
                      ? 'assets/remove_user.svg'
                      : 'assets/add_user.svg')))
        ],
      ),
    );
  }
}
