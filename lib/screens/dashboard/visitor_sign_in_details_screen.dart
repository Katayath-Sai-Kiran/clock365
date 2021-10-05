import 'package:clock365/constants.dart';
import 'package:clock365/customWidgets.dart';
import 'package:clock365/generated/l10n.dart';
import 'package:clock365/models/OrganizationModel.dart';
import 'package:clock365/models/clock_user.dart';
import 'package:clock365/repository/organization_repository.dart';
import 'package:clock365/screens/dashboard/visitor_confirm_screen.dart';
import 'package:clock365/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class VisitorSignInDetailsScreen extends StatefulWidget {
  const VisitorSignInDetailsScreen({Key? key}) : super(key: key);

  @override
  _UserSignInScreenState createState() => _UserSignInScreenState();
}

class _UserSignInScreenState extends State<VisitorSignInDetailsScreen> {
  final TextEditingController _orgNameController = TextEditingController();
  final FocusNode _yourNameFocusNode = FocusNode();
  final FocusNode _orgNameFocusNode = FocusNode();
  final CustomWidgets _customWidgets = CustomWidgets();

  bool _isTermsAndConditionChecked = false;
  OrganizationModel? _selectedOrganization;

  @override
  void initState() {
    super.initState();

    _yourNameFocusNode.addListener(onFocusChange);
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
    final ClockUser currentUser = Hive.box(kUserBox).get(kCurrentUserKey);
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).signInDetails),
      ),
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.all(24),
            child: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    TypeAheadField<OrganizationModel>(
                      loadingBuilder: (_) {
                        return CircularProgressIndicator();
                      },
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: _orgNameController,
                        textInputAction: TextInputAction.done,
                      ),
                      autoFlipDirection: true,
                      noItemsFoundBuilder: (_) => SearchOrganizationItem(
                        organization: OrganizationModel(
                            organizationName: "No Organization Found"),
                      ),
                      suggestionsCallback: (pattern) async {
                        List<OrganizationModel> matchedOrganizations =
                            await organizationRepository
                                .getOrganizationSuggetions(pattern: pattern);
                        if (matchedOrganizations.length > 0) {
                          return matchedOrganizations;
                        } else {
                          return [
                            OrganizationModel(
                                organizationName:
                                    "No Organization Found"),
                          ];
                        }
                      },
                      itemBuilder: (context, OrganizationModel organization) {
                        return SearchOrganizationItem(
                          organization: organization,
                        );
                      },
                      onSuggestionSelected:
                          (OrganizationModel selectedOrganization) {
                        setState(() {
                          if (selectedOrganization.organizationName ==
                              "No Organization Found") {
                            _orgNameController.text = "";
                          } else {
                            _orgNameController.text = selectedOrganization
                                .organizationName
                                .toString();
                            _selectedOrganization = selectedOrganization;
                          }
                        });
//
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            S.of(context).informationBeingUsedConsent,
                            style: Theme.of(context).textTheme.bodyText2,
                          )),
                          CupertinoSwitch(
                            value: _isTermsAndConditionChecked,
                            activeColor: Theme.of(context).colorScheme.primary,
                            onChanged: (newState) {
                              setState(() {
                                _isTermsAndConditionChecked = newState;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_orgNameController.text.isNotEmpty) {
                          if (_isTermsAndConditionChecked) {
                            bool _isLoggingInCurrentOrg =
                                _selectedOrganization!.organizationId ==
                                        currentUser
                                            .currentOrganization!.organizationId
                                    ? true
                                    : false;

                            if (_isLoggingInCurrentOrg) {
                              //logging into current Org
                              if (_selectedOrganization!.visitorSignIn ==
                                  true) {
                                //visitor has permission to login
                                Get.to(
                                  () => VisitorSignInConfirm(
                                      selectedOrganization:
                                          _selectedOrganization),
                                );
                              } else {
                                // Get.to(
                                //   () => VisitorSignInConfirm(
                                //       selectedOrganization:
                                //           _selectedOrganization),
                                // );
                                // visitor is not allowed to login in

                                _customWidgets.failureToste(
                                    text:
                                        "Visitors Cannot SignIn Into ${_selectedOrganization!.organizationName.toString()}",
                                    context: context);
                              }
                            } else {
                              if (_selectedOrganization!.visitorSignIn ==
                                  true) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.white,
                                    elevation: 8.0,
                                    behavior: SnackBarBehavior.floating,
                                    content: Container(
                                      height: 100,
                                      width: _width,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            "Are you sure to logout !",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Container(
                                                width: _width * 0.3,
                                                height: _height * 0.05,
                                                child: OutlinedButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.white),
                                                    side: MaterialStateProperty
                                                        .all(BorderSide(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                    )),
                                                  ),
                                                  onPressed: () {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .hideCurrentSnackBar();

                                                    //Scaffold.of(context).is
                                                  },
                                                  child: Text(
                                                    "Cancle",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: _width * 0.3,
                                                height: _height * 0.05,
                                                child: OutlinedButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary),
                                                  ),
                                                  onPressed: () {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .hideCurrentSnackBar();

                                                    Navigator.of(context).pushNamed(
                                                        kVisitorSignInDetailsScreen);
                                                  },
                                                  child: Text("Logout"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    margin: EdgeInsets.all(16.0),
                                  ),
                                );
                              } else {
                                // Get.to(() => VisitorSignInConfirm(
                                //       selectedOrganization:
                                //           _selectedOrganization,
                                //     ));
                                _customWidgets.failureToste(
                                    text:
                                        "Visitors Cannot SignIn Into ${_selectedOrganization!.organizationName.toString()}",
                                    context: context);
                              }
                            }
                          } else {
                            _customWidgets.failureToste(
                                text: "Plaese accept Terms and Conditions!",
                                context: context);
                          }
                        } else {
                          _customWidgets.failureToste(
                              text: "Organization cannot be empty",
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
}

class SearchOrganizationItem extends StatelessWidget {
  final OrganizationModel organization;
  SearchOrganizationItem({required this.organization});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
          border: Border.all(
        color: kStrokeColor,
      )),
      child: Row(
        children: [
          Expanded(
              child: Container(
            width: Get.width,
            alignment: Alignment.centerLeft,
            height: organization.organizationName != "No Organizations Found"
                ? 24
                : 38,
            child: Text(
              organization.organizationName.toString(),
              style: Theme.of(context).textTheme.bodyText1,
            ),
          )),
          SizedBox(
            width: 16,
          ),
          if (organization.organizationName != "No Organizations Found")
            IconButton(
              onPressed: () {},
              icon: SizedBox(
                height: 24,
                width: 24,
                child: SvgPicture.asset('assets/add_user.svg'),
              ),
            )
        ],
      ),
    );
  }
}
