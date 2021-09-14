import 'package:clock365/elements/semi_circle.dart';
import 'package:clock365/screens/signup/otp_bottom_sheet.dart';
import 'package:clock365/theme/colors.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _businessEmailController =
      TextEditingController();
  final TextEditingController _businessEmailConfirmController =
      TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();

  final FocusNode _businessEmailFocusNode = FocusNode();
  final FocusNode _businessEmailConfirmFocusNode = FocusNode();
  final FocusNode _jobTitleFocusNode = FocusNode();
  bool? _isTermsAndConditionChecked = false;

  @override
  void initState() {
    super.initState();
    _businessEmailFocusNode.addListener(onFocusChange);
    _jobTitleFocusNode.addListener(onFocusChange);
    _businessEmailConfirmFocusNode.addListener(onFocusChange);
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
                  child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SemiCircle(),
          SizedBox(
            height: 32,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Welcome\nPlease Signup',
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
                      controller: _businessEmailController,
                      focusNode: _businessEmailFocusNode,
                      decoration: InputDecoration(
                          hintText: 'Business email address',
                          fillColor: getFillColor(_businessEmailFocusNode)),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextField(
                      controller: _businessEmailConfirmController,
                      focusNode: _businessEmailConfirmFocusNode,
                      decoration: InputDecoration(
                          fillColor:
                              getFillColor(_businessEmailConfirmFocusNode),
                          hintText: 'Confirm Business email address'),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextField(
                      controller: _jobTitleController,
                      focusNode: _jobTitleFocusNode,
                      decoration: InputDecoration(
                          fillColor: getFillColor(_jobTitleFocusNode),
                          hintText: 'Job Title (Optional)'),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _isTermsAndConditionChecked =
                                !_isTermsAndConditionChecked!;
                          });
                        },
                        child: Row(
                          children: [
                            Text(
                              'Terms of use',
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(.75)),
                            ),
                            Checkbox(
                                value: _isTermsAndConditionChecked,
                                onChanged: (newValue) =>
                                    _isTermsAndConditionChecked = newValue)
                          ],
                        )),
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: ElevatedButton(
                          onPressed: () => showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(24),
                                      topRight: Radius.circular(24))),
                              builder: (context) => OTPBottomSheet()),
                          child: Text('Next'),
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 48)),
                        ))
                  ]))
        ],
      )))),
    );
  }
}
