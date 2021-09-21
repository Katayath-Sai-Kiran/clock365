import 'package:clock365/constants.dart';
import 'package:clock365/generated/l10n.dart';
import 'package:clock365/screens/location/location_screen.dart';
import 'package:clock365/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    final Map currentOrganization =
        ModalRoute.of(context)?.settings.arguments as Map;
    _orgNameController..text = currentOrganization["orgnization"]["name"];

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
                        hintText: currentOrganization["orgnization"]["name"] ??
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
                      ),
                      LocationItem(
                        title: "Visitors",
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
                onPressed: () => {
                  Navigator.of(context).pushNamed(
                    kEditStaffRoute,
                    arguments: currentOrganization,
                  ),
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
  LocationItem({Key? key, required this.title}) : super(key: key);

  @override
  _LocationItemState createState() => _LocationItemState();
}

class _LocationItemState extends State<LocationItem> {
  bool switchVal = false;
  bool isStaff = false;
  bool isVisitors = false;
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
                    value: switchVal,
                    onChanged: (newState) {
                      setState(() {
                        if (widget.title == "Staff") {
                          isStaff = true;
                          switchVal = newState;
                        } else {
                          isVisitors = true;
                          switchVal = newState;
                        }
                      });
                    })
              ],
            )),
      ),
    );
  }
}
