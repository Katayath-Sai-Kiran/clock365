import 'package:clock365/elements/semi_circle.dart';
import 'package:clock365/screens/signup/otp_bottom_sheet.dart';
import 'package:clock365/theme/colors.dart';
import 'package:flutter/material.dart';

class SignupIntroduceScreen extends StatefulWidget {
  const SignupIntroduceScreen({Key? key}) : super(key: key);

  @override
  _SignupIntroduceScreenState createState() => _SignupIntroduceScreenState();
}

class _SignupIntroduceScreenState extends State<SignupIntroduceScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _orgNameController = TextEditingController();
  final TextEditingController _websiteNameController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _orgNameFocusNode = FocusNode();
  final FocusNode _websiteNameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _nameFocusNode.addListener(onFocusChange);
    _websiteNameFocusNode.addListener(onFocusChange);
    _orgNameFocusNode.addListener(onFocusChange);
  }

  void onFocusChange() {
    setState(() {});
  }

  Color getFillColor(FocusNode focusNode) =>
      focusNode.hasFocus ? Colors.white : kStrokeColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
              child: SingleChildScrollView(
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 24,
                          ),
                          const SemiCircle(),
                          SizedBox(
                            height: 32,
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'Hello\nLet\'s Introduce',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              )),
                          SizedBox(
                            height: 32,
                          ),
                          Padding(
                              padding: EdgeInsets.all(24),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextField(
                                      controller: _nameController,
                                      focusNode: _nameFocusNode,
                                      decoration: InputDecoration(
                                          hintText: 'Name',
                                          fillColor:
                                              getFillColor(_nameFocusNode)),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    TextField(
                                      controller: _orgNameController,
                                      focusNode: _orgNameFocusNode,
                                      decoration: InputDecoration(
                                          fillColor:
                                              getFillColor(_orgNameFocusNode),
                                          hintText: 'Organization name'),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    TextField(
                                      controller: _websiteNameController,
                                      focusNode: _websiteNameFocusNode,
                                      decoration: InputDecoration(
                                          fillColor: getFillColor(
                                              _websiteNameFocusNode),
                                          hintText: 'Website (Optional)'),
                                    ),
                                  ])),
                          SizedBox(
                            height: 40,
                          ),
                          Spacer(),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              child: ElevatedButton(
                                onPressed: () => showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(24),
                                            topRight: Radius.circular(24))),
                                    builder: (context) => OTPBottomSheet()),
                                child: Text('Next'),
                                style: ElevatedButton.styleFrom(
                                    minimumSize: Size(double.infinity, 48)),
                              )),
                          Spacer()
                        ],
                      ))))),
    );
  }
}
