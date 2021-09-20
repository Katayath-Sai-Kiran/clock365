import 'package:clock365/constants.dart';
import 'package:clock365/generated/l10n.dart';
import 'package:clock365/repository/organization_repository.dart';
import 'package:clock365/repository/userRepository.dart';
import 'package:clock365/theme/colors.dart';
import 'package:clock365/utils/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final TextEditingController _orgNameController = TextEditingController();
  final FocusNode _orgFocusNode = FocusNode();
  final GlobalKey<FormFieldState> _orgNameKey = GlobalKey<FormFieldState>();
  final CustomWidgets _customWidgets = CustomWidgets();

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
    OrganizationRepository organizationRepository =
        Provider.of<OrganizationRepository>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).location),
      ),
      body: SafeArea(
        child: Stack(children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).atWhichSiteIsThisPhoneLocated,
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  key: _orgNameKey,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please enter a valid organization name";
                    }
                    return null;
                  },
                  controller: _orgNameController,
                  focusNode: _orgFocusNode,
                  decoration: InputDecoration(
                      hintText: "Organization Name",
                      fillColor: getFillColor(_orgFocusNode)),
                ),
                SizedBox(
                  height: 24,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: ElevatedButton(
                      onPressed: () async {
                        UserRepository userRepository =
                            Provider.of<UserRepository>(context, listen: false);
                        String orgName = _orgNameController.text.toString();

                        if (_orgNameKey.currentState?.validate() == true) {
                          Box themeBox =
                              await Hive.openBox<dynamic>("themeBox");

                          final String oId = userRepository.userId;

                          final String colorCode =
                              await themeBox.get("primaryColor");
                          final double colorOpacity =
                              await themeBox.get("colorIntensity");

                          String response =
                              await organizationRepository.registerOrganization(
                            data: {
                              "name": orgName,
                              "color_code": colorCode,
                              "color_opacity": colorOpacity,
                              "created_by": oId,
                            },
                            oId: oId,
                            context: context,
                          );
                          if (response == "done") {
                            // userRepository.addOrganizations(
                            //     organization: orgName);
                            _orgNameController.clear();
                          } else {
                            _customWidgets.snacbar(
                                text: response, context: context);
                          }
                        }
                      },
                      child: Text(
                        S.of(context).add,
                        style: Theme.of(context).textTheme.button?.copyWith(
                            color: Theme.of(context).scaffoldBackgroundColor),
                      ),
                    )),
                SizedBox(
                  height: 24,
                ),
                YourSites()
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class YourSites extends StatefulWidget {
  YourSites({Key? key}) : super(key: key);

  @override
  _YourSitesState createState() => _YourSitesState();
}

class _YourSitesState extends State<YourSites> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserRepository>(
        builder: (context, UserRepository userRepository, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            S.of(context).yourSites,
            style: Theme.of(context).textTheme.headline6?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(
            height: 8,
          ),
          ListView.builder(
            padding: EdgeInsets.only(bottom: 96),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: userRepository.owner!.organizations!.length,
            itemBuilder: (context, index) => SiteItem(
              orgName: userRepository.owner!.organizations![index]["name"],
            ),
          ),
        ],
      );
    });
  }
}

class LocationOptionArguments {
  final String? data;
  LocationOptionArguments({this.data});
}

class SiteItem extends StatefulWidget {
  final String orgName;
  SiteItem({required this.orgName});
  @override
  _SiteItemState createState() => _SiteItemState();
}

class _SiteItemState extends State<SiteItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
            border: Border.all(width: 2, color: kStrokeColor),
            borderRadius: BorderRadius.circular(8)),
        child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(kLocationOptionsRoute,
                  arguments: {"orgName": widget.orgName});
            },
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(child: Text(widget.orgName)),
                    SizedBox(
                      width: 16,
                    ),
                    Icon(Icons.arrow_forward_ios_rounded)
                  ],
                ))));
  }
}
