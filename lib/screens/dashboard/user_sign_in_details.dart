import 'package:clock365/constants.dart';
import 'package:clock365/customWidgets.dart';
import 'package:clock365/generated/l10n.dart';
import 'package:clock365/models/OrganizationModel.dart';
import 'package:clock365/models/clock_user.dart';
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
  final CustomWidgets _customWidgets = CustomWidgets();

  bool _isTermsAndConditionChecked = false;
  OrganizationModel? _selectedOrganization;

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
                    TypeAheadField<OrganizationModel>(
                      loadingBuilder: (_) {
                        return CircularProgressIndicator();
                      },
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: _orgNameController,
                        textInputAction: TextInputAction.done,
                      ),
                      suggestionsCallback: (pattern) async {
                        List<OrganizationModel> matchedOrganizations =
                            await organizationRepository
                                .getOrganizationSuggetions(
                                    pattern: pattern, context: context);
                        if (matchedOrganizations.length > 0) {
                          return matchedOrganizations;
                        } else {
                          return [
                            OrganizationModel(
                                organizationName: "No organizations found"),
                          ];
                        }
                      },
                      itemBuilder: (BuildContext context,
                          OrganizationModel organization) {
                        return SearchOrganizationItem(
                            organization: organization);
                      },
                      onSuggestionSelected:
                          (OrganizationModel selectedOrganization) async {
                        setState(() {
                          if (selectedOrganization.organizationName ==
                              "No organizations found") {
                            _orgNameController.text = "";
                          } else {
                            _orgNameController.text = selectedOrganization
                                .organizationName
                                .toString();
                            _selectedOrganization = selectedOrganization;
                          }
                        });
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
                            ClockUser curentUser =
                                Hive.box(kUserBox).get(kCurrentUserKey);

                            bool _isLoggingInCurrentOrg =
                                _selectedOrganization!.organizationId ==
                                        curentUser
                                            .currentOrganization!.organizationId
                                    ? true
                                    : false;

                            if (_isLoggingInCurrentOrg) {
                              //signinig into current organization
                              currentOrganizationSignin();
                            } else {
                              //signing into new orgniazation
                              otherOrganizationSignin();
                            }
                          } else {
                            _customWidgets.failureToste(
                                text: "please accept Terms and Conditions",
                                context: context);
                          }
                        } else {
                          _customWidgets.failureToste(
                              text: "Organization cannot be empty !",
                              context: context);
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

  void otherOrganizationSignin() {
    ClockUser currentUser = Hive.box(kUserBox).get(kCurrentUserKey);

    if (_selectedOrganization!.staffSignIn == true) {
      
      _customWidgets.snacbarWithTwoButtons2(
        currentUser: currentUser,
        selectedOrganization: _selectedOrganization,
        titleText: "Are you sure you want to login !",
        primatyText: "Sign Out",
        secondaryText: "Cancle",
        context: context,
        secondaryCallback: () =>
            ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      );
    } else {
      final String orgName = _selectedOrganization!.organizationName.toString();
      _customWidgets.failureToste(
          text: "Staff Cannot SignIn Into $orgName", context: context);
    }
  }

  void currentOrganizationSignin() {
    print("current org");
    final String orgName = _selectedOrganization!.organizationName.toString();
    ClockUser curentUser = Hive.box(kUserBox).get(kCurrentUserKey);
    if (_selectedOrganization!.staffSignIn == true) {
      List<ClockUser>? selectedOrganizationStaff = _selectedOrganization!.staff;

      bool _canSignIn = false;
      selectedOrganizationStaff?.forEach((element) {
        if (element.id == curentUser.id) {
          _canSignIn = true;
        }
       
      });
       if (_canSignIn) {
        Navigator.of(context).pushNamed(
          kUserConfirmSignInScreen,
          arguments: _selectedOrganization,
        );
      } else {
        _customWidgets.failureToste(
            text: "You are not registered with $orgName", context: context);
      }
    } else {
      _customWidgets.failureToste(
          text: "Staff Cannot SignIn Into $orgName", context: context);
    }
  }

  Future staffSelectOrganization({required Map selectedOrganization}) async {
    String currentUserId = Hive.box(kUserBox).get(kcurrentUserId);
    Map currentOfflineUser = Hive.box(kUserBox).get(currentUserId) ?? {};
    Map currentOrganization = currentOfflineUser["currentOrganization"] ?? {};
    bool _isLoggingInCurrentOrg = selectedOrganization["_id"]["\$oid"] ??
        "" == currentOrganization["_id"]["\$oid"] ??
        "currentOrganizationId";
    if (_isLoggingInCurrentOrg) {
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 2000),
          elevation: 8.0,
          behavior: SnackBarBehavior.floating,
          content: Container(
            child: Text(""),
          ),
          margin: EdgeInsets.all(16.0),
        ),
      );
    }
  }
}

class SearchOrganizationItem extends StatelessWidget {
  final OrganizationModel organization;
  SearchOrganizationItem({required this.organization});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      padding: EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
          border: Border.all(
        color: kStrokeColor,
      )),
      child: Row(
        children: [
          Expanded(
              child: Text(
            organization.organizationName.toString(),
            style: Theme.of(context).textTheme.bodyText1,
          )),
          SizedBox(
            width: 16,
          ),
          if (organization.organizationName.toString() ==
              "No organizations found")
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
