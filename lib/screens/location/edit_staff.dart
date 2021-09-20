import 'package:clock365/constants.dart';
import 'package:clock365/generated/l10n.dart';
import 'package:clock365/models/clock_user.dart';
import 'package:clock365/providers/clock_user_provider.dart';
import 'package:clock365/repository/userRepository.dart';
import 'package:clock365/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

class EditStaffScreen extends StatefulWidget {
  const EditStaffScreen({Key? key}) : super(key: key);

  @override
  _EditStaffScreenState createState() => _EditStaffScreenState();
}

class _EditStaffScreenState extends State<EditStaffScreen> {
  @override
  Widget build(BuildContext context) {
    final double _height = MediaQuery.of(context).size.height;
    final ThemeData themeData = Theme.of(context);
    return Consumer<ClockUserProvider>(
        builder: (context, ClockUserProvider provider, __) {
      List<ClockUser> staff = provider.staff;
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
                      suggestionsCallback: (pattern) async {
                        UserRepository userRepository =
                            Provider.of<UserRepository>(context, listen: false);

                        List<ClockUser> staff =
                            await userRepository.getMatches(pattern: pattern) ??
                                [];

                        List<ClockUser> filteredStaff = staff
                            .where((element) => element.name!
                                .toLowerCase()
                                .startsWith(pattern.toLowerCase()))
                            .toList();

                        if (staff.length == 0) {
                          return <ClockUser>[
                            ClockUser(
                              name: pattern.toString(),
                            ),
                          ];
                        } else {
                          return filteredStaff;
                        }
                      },
                      itemBuilder:
                          (BuildContext context, ClockUser clockUser) =>
                              MemberItem(
                                clockUser: clockUser,
                                isAdd: true,
                                index: 0,
                              ),
                      onSuggestionSelected: (ClockUser clockUser) {
                        provider.addStaff(newStaffMember: clockUser);
                      }),
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
                    itemCount: staff.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => MemberItem(
                      clockUser: staff[index],
                      isAdd: false,
                      index: index,
                    ),
                  )),
                  SizedBox(
                    height: staff.length == 0 ? _height * 0.4 : 32.0,
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
    });
  }
}

class MemberItem extends StatefulWidget {
  final ClockUser clockUser;
  final bool isAdd;
  final int index;
  const MemberItem(
      {Key? key,
      required this.clockUser,
      required this.isAdd,
      required this.index})
      : super(key: key);

  @override
  _MemberItemState createState() => _MemberItemState();
}

class _MemberItemState extends State<MemberItem> {
  @override
  Widget build(BuildContext context) {
    ClockUserProvider provider = Provider.of<ClockUserProvider>(context);
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
              onPressed: () {
                widget.isAdd
                    ? null
                    : provider.deleteStaff(staffIndex: widget.index);
              },
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
