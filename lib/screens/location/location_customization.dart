import 'package:clock365/constants.dart';
import 'package:clock365/generated/l10n.dart';
import 'package:clock365/theme/colors.dart';
import 'package:flutter/material.dart';

class LocationCustomizationScreen extends StatefulWidget {
  const LocationCustomizationScreen({Key? key}) : super(key: key);

  @override
  _LocationCustomizationScreenState createState() =>
      _LocationCustomizationScreenState();
}

class _LocationCustomizationScreenState
    extends State<LocationCustomizationScreen> {
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _colorFocusNode = FocusNode();
  double colorIntensity = 1.0;

  @override
  void initState() {
    super.initState();

    _nameFocusNode.addListener(onFocusChange);
    _colorFocusNode.addListener(onFocusChange);
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
        title: Text(S.of(context).modification),
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: 80,
                child: Container(
                    color: kStrokeColor,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      SizedBox(
                        height: 16,
                      ),
                      Text(S.of(context).color),
                      Flexible(
                          child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 8),
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(48),
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                              child: ColorPicker()))
                    ]))),
            Expanded(
                child: Stack(children: [
              SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(S.of(context).buttons),
                      SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        onPressed: () => {},
                        child: Text(S.of(context).next),
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(colorIntensity)),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(colorIntensity),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Expanded(
                              child: TextField(
                            focusNode: _nameFocusNode,
                            decoration: InputDecoration(
                                hintText: 'Your name',
                                fillColor: getFillColor(_nameFocusNode)),
                          ))
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(S.of(context).intensity,
                          style: Theme.of(context).textTheme.bodyText2),
                      Slider(
                          value: colorIntensity,
                          onChanged: (newValue) {
                            setState(() {
                              colorIntensity = newValue;
                            });
                          }),
                      Text(S.of(context).colorCode),
                      SizedBox(
                        height: 8,
                      ),
                      TextField(
                        focusNode: _colorFocusNode,
                        decoration: InputDecoration(
                            hintText: '#125BB2',
                            fillColor: getFillColor(_colorFocusNode)),
                      )
                    ],
                  )),
              Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: ElevatedButton(
                    onPressed: () =>
                        {Navigator.of(context).pushNamed(kLocationRoute)},
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(colorIntensity)),
                    child: Text(
                      S.of(context).done,
                      style: Theme.of(context).textTheme.button?.copyWith(
                          color: Theme.of(context).scaffoldBackgroundColor),
                    ),
                  ))
            ]))
          ],
        ),
      ),
    );
  }
}

class ColorPicker extends StatefulWidget {
  const ColorPicker({Key? key}) : super(key: key);

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ListView.builder(
            itemCount: allColors.length,
            itemBuilder: (context, index) => InkWell(
                onTap: () => {},
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: allColors[index],
                  ),
                  margin: EdgeInsets.only(top: 12),
                ))));
  }
}
