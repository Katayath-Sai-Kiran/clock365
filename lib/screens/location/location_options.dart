import 'package:clock365/constants.dart';
import 'package:clock365/generated/l10n.dart';
import 'package:clock365/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LocationOptionsScreen extends StatefulWidget {
  const LocationOptionsScreen({Key? key}) : super(key: key);

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
    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).locationOptions),
        ),
        body: SafeArea(
            child: Stack(children: [
          ListView.builder(
              padding:
                  EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 112),
              itemCount: 15,
              itemBuilder: (context, index) => index == 0
                  ? TextField(
                      controller: _orgNameController,
                      focusNode: _orgFocusNode,
                      decoration: InputDecoration(
                          hintText: 'DLF Saket',
                          fillColor: getFillColor(_orgFocusNode)),
                    )
                  : LocationItem()),
          Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: ElevatedButton(
                onPressed: () =>
                    {Navigator.of(context).pushNamed(kEditStaffRoute)},
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
  const LocationItem({Key? key}) : super(key: key);

  @override
  _LocationItemState createState() => _LocationItemState();
}

class _LocationItemState extends State<LocationItem> {
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
                  'Data',
                  style: Theme.of(context).textTheme.button,
                )),
                CupertinoSwitch(value: true, onChanged: (newState) => {})
              ],
            )),
      ),
    );
  }
}
