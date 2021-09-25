import 'package:clock365/constants.dart';
import 'package:clock365/generated/l10n.dart';
import 'package:clock365/providers/user_provider.dart';
import 'package:clock365/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

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
  Color primaryColor = allColors[0];
  int currentIndex = 0;

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
    return Consumer<ClockUserProvider>(
      builder: (context, ClockUserProvider accountProvider, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor.withOpacity(colorIntensity),
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
                          margin:
                              EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(48),
                              color: Theme.of(context).scaffoldBackgroundColor),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: ListView.builder(
                                  itemCount: allColors.length,
                                  itemBuilder: (context, index) => InkWell(
                                      onTap: () {
                                        setState(() {
                                          primaryColor = allColors[index];
                                          currentIndex = index;
                                        });
                                      },
                                      child: Container(
                                        height: 48,
                                        width: 48,
                                        decoration: BoxDecoration(
                                          border: index == currentIndex
                                              ? Border.fromBorderSide(
                                                  BorderSide(width: 2.0),
                                                )
                                              : null,
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          color: allColors[index],
                                        ),
                                        margin: EdgeInsets.only(top: 12),
                                      )))),
                        ))
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
                              primary: primaryColor.withOpacity(colorIntensity),
                            )),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor:
                                  primaryColor.withOpacity(colorIntensity),
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
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
                            activeColor:
                                primaryColor.withOpacity(colorIntensity),
                            value: colorIntensity,
                            min: 0.5,
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
                      onPressed: () async {
                        setTheme();
                      },
                      style: ElevatedButton.styleFrom(
                          primary: primaryColor.withOpacity(colorIntensity)),
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
      ),
    );
  }

  Future setTheme() async {
    List<String> colors = [
      "0xFF6756D8",
      "0xFFFDBE00",
      "0xFF244F43",
      "0xFFFF6957",
    ];

    Box userBox = await Hive.openBox<dynamic>(kUserBox);
    String? currentUserId = userBox.get(kcurrentUserId);
    if (currentUserId != null) {
      Map userData = userBox.get(currentUserId);
      Map updatedThemeData = userData["themeData"];
      updatedThemeData = {
        "primaryColor": colors[currentIndex],
        "colorIntensity": colorIntensity,
      };
      userData.update("themeData", (value) => updatedThemeData);
      await userBox.put(currentUserId, userData);
    }

    Navigator.of(context).pushNamed(
      kLocationRoute,
      arguments: {
        "primaryColor": colors[currentIndex],
        "colorIntensity": colorIntensity,
      },
    );
  }
}

// class ColorPicker extends StatefulWidget {
//   const ColorPicker({Key? key}) : super(key: key);

//   @override
//   _ColorPickerState createState() => _ColorPickerState();
// }

// class _ColorPickerState extends State<ColorPicker> {
//   final int selectedIndex = 0;
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ClockUserProvider>(
//       builder: (context, ClockUserProvider accountProvider, child) => ClipRRect(
//           borderRadius: BorderRadius.circular(16),
//           child: ListView.builder(
//               itemCount: allColors.length,
//               itemBuilder: (context, index) => InkWell(
//                   onTap: () {
                    
//                   },
//                   child: Container(
//                     height: 48,
//                     width: 48,
//                     decoration: BoxDecoration(
//                       border: index == selectedIndex
//                           ? Border.fromBorderSide(
//                               BorderSide(width: 2.0),
//                             )
//                           : null,
//                       borderRadius: BorderRadius.circular(24),
//                       color: allColors[index],
//                     ),
//                     margin: EdgeInsets.only(top: 12),
//                   )))),
//     );
//   }
// }
//ksaikiran0407@gmail.com
