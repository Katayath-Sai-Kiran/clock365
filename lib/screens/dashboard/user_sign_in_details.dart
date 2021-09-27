import 'package:clock365/constants.dart';
import 'package:clock365/generated/l10n.dart';
import 'package:clock365/repository/organization_repository.dart';
import 'package:clock365/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class UserSignInScreen extends StatefulWidget {
  const UserSignInScreen({Key? key}) : super(key: key);

  @override
  _UserSignInScreenState createState() => _UserSignInScreenState();
}

class _UserSignInScreenState extends State<UserSignInScreen> {
  final TextEditingController _orgNameController = TextEditingController();
  final FocusNode _orgNameFocusNode = FocusNode();

  bool _isTermsAndConditionChecked = false;
  Map _selectedOrganization = {};

  @override
  void initState() {
    super.initState();

    _orgNameFocusNode.addListener(onFocusChange);
  }

  void onFocusChange() {
    setState(() {});
  }

  Color getFillColor(FocusNode focusNode) =>
      focusNode.hasFocus ? Colors.white : kStrokeColor;

  @override
  Widget build(BuildContext context) {
    final OrganizationRepository organizationRepository =
        Provider.of(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).signInDetails),
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(24),
            child: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 32,
                    ),
                    TypeAheadField(
                      loadingBuilder: (_) {
                        return CircularProgressIndicator();
                      },
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: _orgNameController,
                        textInputAction: TextInputAction.done,
                      ),
                      suggestionsCallback: (pattern) async {
                        List<Map> matchedOrganizations =
                            await organizationRepository
                                .getOrganizationSuggetions(pattern: pattern);
                        if (matchedOrganizations.length > 0) {
                          return matchedOrganizations;
                        } else {
                          return [
                            {"name": "No organizations found"}
                          ];
                        }
                      },
                      itemBuilder: (BuildContext context, Map organization) {
                        return SearchOrganizationItem(
                            organization: organization);
                      },
                      onSuggestionSelected: (Map organization) async {
                        staffSelectOrganization(
                            selectedOrganization: organization);
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextButton(
                      onPressed: () => {},
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            S.of(context).informationBeingUsedConsent,
                            style: Theme.of(context).textTheme.bodyText2,
                          )),
                          CupertinoSwitch(
                            value: _isTermsAndConditionChecked,
                            onChanged: (newState) {
                              setState(() {
                                _isTermsAndConditionChecked = newState;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
                Container(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_orgNameController.text.isNotEmpty) {
                          if (_isTermsAndConditionChecked) {
                            Navigator.of(context).pushNamed(
                              kUserConfirmSignInScreen,
                              arguments: _selectedOrganization,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text("plaese accept Terms and Conditions"),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Organization Cannot be Empty"),
                            ),
                          );
                        }
                      },
                      child: Text(
                        S.of(context).actionContinue,
                        style: Theme.of(context).textTheme.button?.copyWith(
                            color: Theme.of(context).scaffoldBackgroundColor),
                      ),
                    ))
              ],
            )),
      ),
    );
  }

  Future staffSelectOrganization({required Map selectedOrganization}) async {
    String currentUserId = Hive.box(kUserBox).get(kcurrentUserId);
    print(
        "current Offline user is ${Hive.box(kUserBox).get(currentUserId)["currentOrganization"]}");
    setState(() {
      _orgNameController.text = selectedOrganization["name"];
      _selectedOrganization = selectedOrganization;
    });
  }
}

class SearchOrganizationItem extends StatelessWidget {
  final Map organization;
  SearchOrganizationItem({required this.organization});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: organization.isEmpty ||
              organization["name"] == "No organizations found"
          ? 40
          : null,
      padding: EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
          border: Border.all(
        color: kStrokeColor,
      )),
      child: Row(
        children: [
          Expanded(
              child: Text(
            organization.isEmpty
                ? "No organizations found"
                : organization["name"],
            style: Theme.of(context).textTheme.bodyText1,
          )),
          SizedBox(
            width: 16,
          ),
          if (organization.isNotEmpty &&
              organization["name"] != "No organizations found")
            IconButton(
              onPressed: () {},
              icon: SizedBox(
                height: 24,
                width: 24,
                child: SvgPicture.asset('assets/add_user.svg'),
              ),
            ),
        ],
      ),
    );
  }
}
