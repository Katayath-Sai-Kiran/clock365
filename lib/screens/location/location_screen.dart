import 'package:clock365/constants.dart';
import 'package:clock365/generated/l10n.dart';
import 'package:clock365/providers/organization_provider.dart';
import 'package:clock365/providers/user_provider.dart';
import 'package:clock365/repository/organization_repository.dart';
import 'package:clock365/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
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
    final Color selectedColor = Color(int.parse(themeData["primaryColor"]))
        .withOpacity(themeData["colorIntensity"]);

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
                    suggestionsCallback: (pattern) async {
                      List<Map> matchedOrganizations =
                          await organizationRepository
                              .getOrganizationSuggetions(pattern: pattern);
                      if (matchedOrganizations.length > 0) {
                        return matchedOrganizations;
                      } else {
                        return [
                          {"name": _orgNameController.text.toString()}
                        ];
                      }
                    },
                    itemBuilder: (BuildContext context, Map organization) {
                      return SearchOrganizationItem(
                        organization: organization,
                        orgNameController: _orgNameController,
                        selectedColor: selectedColor,
                        organizationRepository: organizationRepository,
                        themeData: themeData,
                      );
                    },
                    onSuggestionSelected: (Map organization) async {
                      registerOrganization(
                          themeData: themeData,
                          organizationRepository: organizationRepository);
                    }),
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
                YourSites()
              ],
            ),
          ),
        ]),
      ),
    );
  }

  void registerOrganization({
    required Map themeData,
    required OrganizationRepository organizationRepository,
  }) async {
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

class SearchOrganizationItem extends StatelessWidget {
  final Map organization;
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
    final String orgname = orgNameController.text.toString();
    return InkWell(
      onTap: () async {
        String orgName = orgNameController.text.toString();

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

        orgNameController.clear();
      },
      child: Container(
        height: organization.isEmpty ? 50 : null,
        padding: EdgeInsets.only(left: 16),
        decoration: BoxDecoration(
            border: Border.all(
          color: kStrokeColor,
        )),
        child: Row(
          children: [
            Expanded(
                child: Text(
              organization.isNotEmpty ? organization["name"] : orgname,
              style: Theme.of(context).textTheme.bodyText1,
            )),
            SizedBox(
              width: 16,
            ),
            if (organization.isNotEmpty)
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
}
