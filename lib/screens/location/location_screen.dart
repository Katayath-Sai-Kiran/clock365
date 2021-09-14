import 'package:clock365/constants.dart';
import 'package:clock365/generated/l10n.dart';
import 'package:clock365/theme/colors.dart';
import 'package:flutter/material.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
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
                TextField(
                  controller: _orgNameController,
                  focusNode: _orgFocusNode,
                  decoration: InputDecoration(
                      hintText: 'DLF Saket',
                      fillColor: getFillColor(_orgFocusNode)),
                ),
                SizedBox(
                  height: 24,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: ElevatedButton(
                      onPressed: () => {},
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
          Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: ElevatedButton(
                onPressed: () =>
                    {Navigator.of(context).pushNamed(kLocationOptionsRoute)},
                child: Text(
                  S.of(context).done,
                  style: Theme.of(context).textTheme.button?.copyWith(
                      color: Theme.of(context).scaffoldBackgroundColor),
                ),
              ))
        ]),
      ),
    );
  }
}

class YourSites extends StatefulWidget {
  const YourSites({Key? key}) : super(key: key);

  @override
  _YourSitesState createState() => _YourSitesState();
}

class _YourSitesState extends State<YourSites> {
  @override
  Widget build(BuildContext context) {
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
            itemCount: 10,
            itemBuilder: (context, index) => SiteItem())
      ],
    );
  }
}

class SiteItem extends StatefulWidget {
  const SiteItem({Key? key}) : super(key: key);

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
            onTap: () => {},
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(child: Text('DLF Saket')),
                    SizedBox(
                      width: 16,
                    ),
                    Icon(Icons.arrow_forward_ios_rounded)
                  ],
                ))));
  }
}
