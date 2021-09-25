import 'package:clock365/constants.dart';
import 'package:clock365/generated/l10n.dart';
import 'package:clock365/providers/organization_provider.dart';
import 'package:clock365/providers/user_provider.dart';
import 'package:clock365/repository/organization_repository.dart';
import 'package:clock365/theme/colors.dart';
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
    Map themeData = ModalRoute.of(context)!.settings.arguments as Map;

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
                  validator: (val) => val!.isEmpty
                      ? "Please enter a valid organization name"
                      : null,
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
                        String orgName = _orgNameController.text.toString();

                        if (_orgNameKey.currentState?.validate() == true) {
                          Box userBox = await Hive.openBox(kUserBox);
                          String oId = userBox.get(kcurrentUserId);

                          await organizationRepository.registerOrganization(
                            data: {
                              "name": orgName,
                              "color_code": themeData["primaryColor"],
                              "color_opacity": themeData["colorIntensity"],
                              "created_by": oId,
                            },
                            oId: oId,
                            context: context,
                          );

                          _orgNameController.clear();
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
    return Consumer<ClockUserProvider>(
        builder: (context, ClockUserProvider userRepository, _) {
      List? organizations = userRepository.owner!.organizations ?? [];
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
            itemCount: organizations.length,
            itemBuilder: (context, index) => SiteItem(
              organization: organizations[index],
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
  final Map organization;
  SiteItem({required this.organization});
  @override
  _SiteItemState createState() => _SiteItemState();
}

class _SiteItemState extends State<SiteItem> {
  @override
  Widget build(BuildContext context) {
    final OrganizationProvider organizationProvider =
        Provider.of<OrganizationProvider>(context, listen: false);
    return Container(
      margin: EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
          border: Border.all(width: 2, color: kStrokeColor),
          borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: () async {
          await organizationProvider.setCurrentOrganization(
              updatedOrganization: widget.organization);

          Navigator.of(context).pushNamed(kLocationOptionsRoute, arguments: {
            "orgnization": widget.organization,
          });
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(child: Text(widget.organization["name"] ?? "name")),
              SizedBox(
                width: 16,
              ),
              Icon(Icons.arrow_forward_ios_rounded)
            ],
          ),
        ),
      ),
    );
  }
}
