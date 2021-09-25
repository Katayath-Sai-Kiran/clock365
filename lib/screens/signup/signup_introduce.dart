import 'package:clock365/constants.dart';
import 'package:clock365/elements/semi_circle.dart';
import 'package:clock365/providers/user_provider.dart';
import 'package:clock365/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupIntroduceScreen extends StatefulWidget {
  const SignupIntroduceScreen({Key? key}) : super(key: key);

  @override
  _SignupIntroduceScreenState createState() => _SignupIntroduceScreenState();
}

class _SignupIntroduceScreenState extends State<SignupIntroduceScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _orgNameController = TextEditingController();
  final TextEditingController _websiteNameController = TextEditingController();

  final GlobalKey<FormFieldState> _nameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _orgNameKey =
      GlobalKey<FormFieldState<String>>();

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
    Map userDetails = ModalRoute.of(context)!.settings.arguments as Map;
    return Consumer<ClockUserProvider>(
      builder: (context, ClockUserProvider accountProvider, child) => Scaffold(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextFormField(
                                        onFieldSubmitted: (val) {
                                          _nameKey.currentState?.validate();
                                        },
                                        key: _nameKey,
                                        validator: (string) =>
                                            string!.isEmpty ||
                                                    string.length == 0
                                                ? "Please enter a valid name"
                                                : null,
                                        textInputAction: TextInputAction.next,
                                        controller: _nameController,
                                        focusNode: _nameFocusNode,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        decoration: InputDecoration(
                                            hintText: 'Name',
                                            fillColor:
                                                getFillColor(_nameFocusNode)),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      TextFormField(
                                        textCapitalization:
                                            TextCapitalization.words,
                                        onFieldSubmitted: (val) {
                                          _orgNameKey.currentState?.validate();
                                        },
                                        key: _orgNameKey,
                                        validator: (string) => string!.isEmpty
                                            ? "Please enter a valid Organization name"
                                            : null,
                                        textInputAction: TextInputAction.next,
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
                                      TextFormField(
                                        textInputAction: TextInputAction.done,
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
                                  onPressed: () async {
                                    final String name =
                                        _nameController.text.toString();
                                    final String organization =
                                        _orgNameController.text.toString();
                                    final String website =
                                        _websiteNameController.text.toString();
                                    if (_nameKey.currentState?.validate() ==
                                            true &&
                                        _orgNameKey.currentState?.validate() ==
                                            true) {
                                      _nameController.clear();
                                      _orgNameController.clear();
                                      _websiteNameController.clear();
                                      Map userData = {
                                        "name": name,
                                        "organization": organization,
                                        "website": website,
                                        "mail": userDetails["mail"],
                                        "job_title": userDetails["job_title"],
                                      };
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                        kSignupPasswordRoute,
                                        arguments: userData,
                                      );
                                    }
                                  },
                                  child: Text('Next'),
                                  style: ElevatedButton.styleFrom(
                                      minimumSize: Size(double.infinity, 48)),
                                )),
                            Spacer()
                          ],
                        ))))),
      ),
    );
  }
}
