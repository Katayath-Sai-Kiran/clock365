import 'package:clock365/constants.dart';
import 'package:clock365/generated/l10n.dart';
import 'package:clock365/models/OrganizationModel.dart';
import 'package:clock365/models/clock_user.dart';
import 'package:clock365/repository/organization_repository.dart';
import 'package:clock365/repository/userRepository.dart';
import 'package:clock365/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
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

    final Color selectedColor = Color(int.parse(themeData["primaryColor"]))
        .withOpacity(themeData["colorIntensity"]);
    OrganizationRepository organizationRepository =
        Provider.of<OrganizationRepository>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).location),
        backgroundColor: selectedColor,
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
                TypeAheadField(
                    loadingBuilder: (_) {
                      return CircularProgressIndicator();
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: _orgNameController,
                      textInputAction: TextInputAction.done,
                    ),
                    suggestionsCallback: (pattern) =>
                        getSuggestions(pattern: pattern),
                    itemBuilder:
                        (BuildContext context, OrganizationModel organization) {
                      return SearchOrganizationItem(
                        organization: organization,
                        orgNameController: _orgNameController,
                        selectedColor: selectedColor,
                        organizationRepository: organizationRepository,
                        themeData: themeData,
                      );
                    },
                    onSuggestionSelected:
                        (OrganizationModel organization) async {}),
                SizedBox(
                  height: 24,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(selectedColor),
                    ),
                    onPressed: () async {},
                    child: Text(
                      S.of(context).add,
                      style: Theme.of(context).textTheme.button?.copyWith(
                          color: Theme.of(context).scaffoldBackgroundColor),
                    ),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                YourSites(
                  themeData: themeData,
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Future<List<OrganizationModel>> getSuggestions(
      {required String pattern}) async {
    OrganizationRepository organizationRepository =
        Provider.of<OrganizationRepository>(context, listen: false);
    List<OrganizationModel> matchedOrganizations = await organizationRepository
        .getOrganizationSuggetions(pattern: pattern);
    if (matchedOrganizations.length > 0) {
      return matchedOrganizations;
    } else {
      return [
        OrganizationModel(organizationName: _orgNameController.text.toString()),
      ];
    }
  }

  void registersdfOrganization({
    required Map selectedOrganization,
    required Map themeData,
    required OrganizationRepository organizationRepository,
  }) async {
    print("called");
    print(selectedOrganization);
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
        context: context,
      );

      _orgNameController.clear();
    }
  }
}

class YourSites extends StatefulWidget {
  final Map themeData;
  YourSites({Key? key, required this.themeData}) : super(key: key);

  @override
  _YourSitesState createState() => _YourSitesState();
}

class _YourSitesState extends State<YourSites> {
  @override
  Widget build(BuildContext context) {
    ClockUser currentUser = Hive.box(kUserBox).get(kCurrentUserKey);
    final UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    return FutureBuilder(
      future: userRepository.getCurrentSites(userId: currentUser.id.toString()),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        List<OrganizationModel> organizations = snapshot.data;

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
                themeData: widget.themeData,
              ),
            )
          ],
        );
      },
    );
  }
}

class LocationOptionArguments {
  final String? data;
  LocationOptionArguments({this.data});
}

class SiteItem extends StatefulWidget {
  final OrganizationModel organization;
  final Map themeData;
  SiteItem({required this.organization, required this.themeData});
  @override
  _SiteItemState createState() => _SiteItemState();
}

class _SiteItemState extends State<SiteItem> {
  @override
  Widget build(BuildContext context) {
    final OrganizationRepository organizationProvider =
        Provider.of<OrganizationRepository>(context, listen: false);
    return Container(
      margin: EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
          border: Border.all(width: 2, color: kStrokeColor),
          borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: () async {
          await organizationProvider.setCurrentOrganization(
              colorCode: widget.themeData["primaryColor"],
              colorOpasity: widget.themeData["colorIntensity"],
              updatedOrganization: widget.organization);

          Navigator.of(context).pushNamed(kLocationOptionsRoute, arguments: {
            "organization": widget.organization,
          });
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                  child: Text(widget.organization.organizationName ??
                      "organization name")),
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

class SearchOrganizationItem extends StatelessWidget {
  final OrganizationModel organization;
  final TextEditingController orgNameController;
  final Color selectedColor;
  final OrganizationRepository organizationRepository;
  final Map themeData;
  SearchOrganizationItem({
    required this.organization,
    required this.orgNameController,
    required this.organizationRepository,
    required this.selectedColor,
    required this.themeData,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectSuggestion(
        context: context,
        organization: organization,
      ),
      child: Container(
        height: 50,
        padding: EdgeInsets.only(left: 16),
        decoration: BoxDecoration(
            border: Border.all(
          color: kStrokeColor,
        )),
        child: Row(
          children: [
            Expanded(
                child: Text(
              organization.organizationName!.isEmpty == true
                  ? "No Organizations found"
                  : organization.organizationName.toString(),
              style: Theme.of(context).textTheme.bodyText1,
            )),
            SizedBox(
              width: 16,
            ),
            if (organization.organizationName!.isEmpty != true)
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
      ),
    );
  }

  Future selectSuggestion({
    required BuildContext context,
    required OrganizationModel? organization,
  }) async {
    ClockUser user = Hive.box(kUserBox).get(kCurrentUserKey);
    print(user.id);
    if (organization!.organizationId == null) {
      await organizationRepository.registerOrganization(
        data: {
          "name": organization.organizationName,
          "color_code": themeData["primaryColor"],
          "color_opacity": themeData["colorIntensity"],
          "created_by": user.id,
        },
        context: context,
      );
    } else {
      //already existed organization
      await organizationRepository.addExistingOrganization(data: {
        "user_id": user.id,
        "org_id": organization.organizationId,
      }, context: context);
    }

    orgNameController.clear();
  }
}
