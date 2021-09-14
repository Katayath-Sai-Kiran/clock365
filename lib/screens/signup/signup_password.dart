import 'package:clock365/elements/semi_circle.dart';
import 'package:clock365/screens/signup/otp_bottom_sheet.dart';
import 'package:clock365/theme/colors.dart';
import 'package:flutter/material.dart';

class SignupPasswordScreen extends StatefulWidget {
  const SignupPasswordScreen({Key? key}) : super(key: key);

  @override
  _SignupPasswordScreenState createState() => _SignupPasswordScreenState();
}

class _SignupPasswordScreenState extends State<SignupPasswordScreen> {
  final TextEditingController _createPasswordController =
      TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FocusNode _createPasswordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _confirmPasswordFocusNode.addListener(onFocusChange);
    _createPasswordFocusNode.addListener(onFocusChange);
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 48,
                          ),
                          const SemiCircle(),
                          SizedBox(
                            height: 32,
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'Hello\nJohn',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              )),
                          Padding(
                              padding: EdgeInsets.all(24),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextField(
                                      controller: _createPasswordController,
                                      focusNode: _createPasswordFocusNode,
                                      decoration: InputDecoration(
                                          fillColor: getFillColor(
                                              _createPasswordFocusNode),
                                          hintText: 'Password'),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    TextField(
                                      controller: _confirmPasswordController,
                                      focusNode: _confirmPasswordFocusNode,
                                      decoration: InputDecoration(
                                          fillColor: getFillColor(
                                              _confirmPasswordFocusNode),
                                          hintText: 'Confirm password'),
                                    ),
                                    SizedBox(
                                      height: 40,
                                    ),
                                  ])),
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
