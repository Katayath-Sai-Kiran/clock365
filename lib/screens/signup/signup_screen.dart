import 'package:clock365/customWidgets.dart';
import 'package:clock365/elements/semi_circle.dart';
import 'package:clock365/repository/userRepository.dart';
import 'package:clock365/screens/signup/otp_bottom_sheet.dart';
import 'package:clock365/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  final GlobalKey<FormFieldState> _mailKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _confirmMailKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _jobTitleKey = GlobalKey<FormFieldState>();

  bool? _isTermsAndConditionChecked = false;
  bool _isLoading = false;

  final CustomWidgets _customWidgets = CustomWidgets();

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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: SafeArea(
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
                            TextFormField(
                              validator: (val) => val?.isEmpty == true ||
                                      val?.contains("@") != true
                                  ? "Email is badly formated"
                                  : null,
                              onFieldSubmitted: (val) {
                                _mailKey.currentState!.validate();
                              },
                              key: _mailKey,
                              textInputAction: TextInputAction.next,
                              controller: _businessEmailController,
                              focusNode: _businessEmailFocusNode,
                              decoration: InputDecoration(
                                  hintText: 'Business email address',
                                  fillColor:
                                      getFillColor(_businessEmailFocusNode)),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            TextFormField(
                              onFieldSubmitted: (val) {
                                _confirmMailKey.currentState!.validate();
                              },
                              validator: (val) {
                                if (val?.isEmpty == true ||
                                    val?.contains("@") == false) {
                                  if (val != _businessEmailController.text) {
                                    _businessEmailConfirmController.clear();
                                    return "organigation mail and confirmation mail are not equal";
                                  }
                                }
                                return null;
                              },
                              key: _confirmMailKey,
                              textInputAction: TextInputAction.next,
                              controller: _businessEmailConfirmController,
                              focusNode: _businessEmailConfirmFocusNode,
                              decoration: InputDecoration(
                                  fillColor: getFillColor(
                                      _businessEmailConfirmFocusNode),
                                  hintText: 'Confirm Business email address'),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.name,
                              textCapitalization: TextCapitalization.words,
                              key: _jobTitleKey,
                              textInputAction: TextInputAction.done,
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
                                        onChanged: (newValue) {
                                          setState(() {
                                            _isTermsAndConditionChecked =
                                                newValue;
                                          });
                                        })
                                  ],
                                )),
                            SizedBox(
                              height: 40,
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                child: ElevatedButton(
                                  onPressed: signUp,
                                  child: Text('Next'),
                                  style: ElevatedButton.styleFrom(
                                      minimumSize: Size(double.infinity, 48)),
                                ))
                          ]))
                ],
              )))),
            ),
    );
  }

  Future signUp() async {
    final UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);

    String mail = _businessEmailController.text.toString();
    String jobTitle = _jobTitleController.text.toString();

    if (_mailKey.currentState!.validate() == true &&
        _confirmMailKey.currentState!.validate()) {
      if (_isTermsAndConditionChecked == true) {
        setState(() {
          _isLoading = true;
        });
        String? res =
            await userRepository.generateOTP(mail: mail, context: context);
        setState(() {
          _isLoading = false;
        });
        if (res == "done") {
          _businessEmailConfirmController.clear();
          _businessEmailController.clear();
          _jobTitleController.clear();

          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24))),
              builder: (context) {
                return OTPBottomSheet(mail: mail, jobTitle: jobTitle);
              });
        } else {
          _businessEmailConfirmController.clear();
          _businessEmailController.clear();
        }
      } else {
        _customWidgets.failureToste(
            text: "Please accept terms and conditions", context: context);
      }
    }
  }
}
