import 'package:clock365/constants.dart';
import 'package:clock365/generated/l10n.dart';
import 'package:clock365/repository/userRepository.dart';
import 'package:clock365/screens/location/location_screen.dart';
import 'package:clock365/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:clock365/models/OrganizationModel.dart';
import 'package:provider/provider.dart';

class LocationOptionsScreen extends StatefulWidget {
  final LocationOptionArguments? arguments;
  LocationOptionsScreen({Key? key, this.arguments}) : super(key: key);

  @override
  _LocationOptionsScreenState createState() => _LocationOptionsScreenState();
}

class _LocationOptionsScreenState extends State<LocationOptionsScreen> {
  final TextEditingController _orgNameController = TextEditingController();
  final FocusNode _orgFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _orgFocusNode.addListener(onFocusChange);
  }

  void onFocusChange() {
    setState(() {});
  }

  Color getFillColor(FocusNode focusNode) =>
      focusNode.hasFocus ? Colors.white : kStrokeColor;

  @override
  Widget build(BuildContext context) {
    final Map arguements = ModalRoute.of(context)?.settings.arguments as Map;
    OrganizationModel currentOrganization = arguements["organization"];
    _orgNameController..text = currentOrganization.organizationName.toString();
    final UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).locationOptions),
        ),
        body: SafeArea(
            child: Stack(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "Name of site",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextField(
                    controller: _orgNameController,
                    focusNode: _orgFocusNode,
                    decoration: InputDecoration(
                        hintText: currentOrganization.organizationName ??
                            "DFL Scaket",
                        fillColor: getFillColor(_orgFocusNode)),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          "Who can sign In",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      LocationItem(
                        title: "Staff",
                        selectedOrganization: currentOrganization,
                      ),
                      LocationItem(
                        title: "Visitors",
                        selectedOrganization: currentOrganization,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: ElevatedButton(
                onPressed: () {
                  print(currentOrganization.organizationId);
                  userRepository.updateSignInStatus(data: {
                    "org_id": currentOrganization.organizationId,
                    "staff_sign_in": currentOrganization.staffSignIn,
                    "visitor_sign_in": currentOrganization.visitorSignIn,
                  }, context: context);
                  Navigator.of(context).pushNamed(
                    kEditStaffRoute,
                    arguments: currentOrganization,
                  );
                },
                child: Text(
                  S.of(context).done,
                  style: Theme.of(context).textTheme.button?.copyWith(
                      color: Theme.of(context).scaffoldBackgroundColor),
                ),
              ))
        ])));
  }
}

class LocationItem extends StatefulWidget {
  final String? title;
  final OrganizationModel? selectedOrganization;
  LocationItem({Key? key, required this.title, this.selectedOrganization})
      : super(key: key);

  @override
  _LocationItemState createState() => _LocationItemState();
}

class _LocationItemState extends State<LocationItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
          border: Border.all(width: 2, color: kStrokeColor),
          borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: () => {},
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  widget.title.toString(),
                  style: Theme.of(context).textTheme.button,
                )),
                CupertinoSwitch(
                    value: widget.title == "Staff"
                        ? widget.selectedOrganization!.staffSignIn.toString() ==
                                "true"
                            ? true
                            : false
                        : widget.selectedOrganization!.visitorSignIn
                                    .toString() ==
                                "true"
                            ? true
                            : false,
                    onChanged: (newState) {
                      setState(() {
                        if (widget.title == "Staff") {
                          widget.selectedOrganization!.staffSignIn = newState;
                        } else {
                          widget.selectedOrganization!.visitorSignIn = newState;
                        }
                      });
                    })
              ],
            )),
      ),
    );
  }
}
