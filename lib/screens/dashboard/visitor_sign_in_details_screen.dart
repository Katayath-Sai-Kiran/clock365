import 'package:clock365/constants.dart';
import 'package:clock365/generated/l10n.dart';
import 'package:clock365/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class VisitorSignInDetailsScreen extends StatefulWidget {
  const VisitorSignInDetailsScreen({Key? key}) : super(key: key);

  @override
  _UserSignInScreenState createState() => _UserSignInScreenState();
}

class _UserSignInScreenState extends State<VisitorSignInDetailsScreen> {
  final TextEditingController _orgNameController = TextEditingController();
  final FocusNode _yourNameFocusNode = FocusNode();
  final FocusNode _orgNameFocusNode = FocusNode();

  final List<Map> organizations = [
    {"name": "Wielabs"},
    {"name": "Xavior School"},
  ];

  bool _isTermsAndConditionChecked = false;
  Map _selectedOrganization = {};

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
                    TypeAheadField(
                      getImmediateSuggestions: true,
                      loadingBuilder: (_) {
                        return CircularProgressIndicator();
                      },
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: _orgNameController,
                        textInputAction: TextInputAction.done,
                      ),
                      suggestionsCallback: (pattern) async {
                        return organizations;
                      },
                      itemBuilder: (_, Map organization) {
                        return SearchOrganizationItem(
                            organization: organization);
                      },
                      onSuggestionSelected: (Map organization) {
                        setState(() {
                          _orgNameController.text = organization["name"];
                          _selectedOrganization = organization;
                        });
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
                            Navigator.of(context)
                                .pushNamed(kUserConfirmSignInScreen);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text("Plaese accept Terms and Conditions"),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Organization cannot be empty"),
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
}

class SearchOrganizationItem extends StatelessWidget {
  final Map organization;
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
              child: Text(
            organization["name"],
            style: Theme.of(context).textTheme.bodyText1,
          )),
          SizedBox(
            width: 16,
          ),
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
