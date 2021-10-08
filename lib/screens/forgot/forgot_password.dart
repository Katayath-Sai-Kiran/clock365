import 'package:clock365/elements/semi_circle.dart';
import 'package:clock365/providers/user_provider.dart';
import 'package:clock365/repository/userRepository.dart';
import 'package:clock365/screens/login/login_screen.dart';
import 'package:clock365/screens/signup/otp_bottom_sheet.dart';
import 'package:clock365/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormFieldState> _newMailKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _confirmKey = GlobalKey<FormFieldState>();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final FocusNode _newPasswordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _confirmPasswordFocusNode.addListener(onFocusChange);
    _newPasswordFocusNode.addListener(onFocusChange);
    _emailFocusNode.addListener(onFocusChange);
  }

  void onFocusChange() {
    setState(() {});
  }
  

  Color getFillColor(FocusNode focusNode) =>
      focusNode.hasFocus ? Colors.white : kStrokeColor;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _emailKey = GlobalKey<FormFieldState>();

  bool _isVerified = false;

  verifyResetMail() async {
    ClockUserProvider clockUserProvider =
        Provider.of<ClockUserProvider>(context, listen: false);

    if (_emailKey.currentState!.validate()) {
      clockUserProvider.updateVerifyingStatus(updatedStatus: 2);

      final UserRepository userRepository =
          Provider.of<UserRepository>(context, listen: false);
      String? res = await userRepository.resetGenerateOTP(
          mail: _emailController.text.toString(), context: context);
      if (res == "done")
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24))),
            builder: (context) {
              return OTPBottomSheet(
                  type: 2,
                  mail: _emailController.text.toString(),
                  jobTitle: "");
            });

      if (clockUserProvider.verifyingStatus == 3) {
        setState(() {
          _isVerified = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ClockUserProvider>(
        builder: (context, ClockUserProvider clockUserProvider, _) {
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
                          'Password Reset',
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
                        child: Form(
                          key: _formKey,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  textInputAction: TextInputAction.done,
                                  key: _emailKey,
                                  validator: (email) => email!.isEmpty == true
                                      ? "Email is badly formated"
                                      : null,
                                  controller: _emailController,
                                  focusNode: _emailFocusNode,
                                  decoration: InputDecoration(
                                      hintText: 'Email',
                                      fillColor: getFillColor(_emailFocusNode)),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    child: clockUserProvider.verifyingStatus ==
                                            1
                                        ? Text('Verify')
                                        : clockUserProvider.verifyingStatus == 2
                                            ? Text("verifying")
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text("verified "),
                                                  CircleAvatar(
                                                    minRadius: 8.0,
                                                    backgroundColor:
                                                        Colors.green,
                                                    maxRadius: 8.0,
                                                    child: Icon(
                                                      Icons.done_rounded,
                                                      color: Colors.white,
                                                      size: 12,
                                                    ),
                                                  )
                                                ],
                                              ),
                                    onPressed: verifyResetMail,
                                  ),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                  key: _newMailKey,
                                  textInputAction: TextInputAction.next,
                                  obscureText: _isPasswordVisible,
                                  validator: (password) => password!.isEmpty
                                      ? "password cannot be empty"
                                      : null,
                                  controller: _newPasswordController,
                                  focusNode: _newPasswordFocusNode,
                                  decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _isPasswordVisible =
                                                !_isPasswordVisible;
                                          });
                                        },
                                        icon: Icon(Icons.visibility,
                                            color: _isPasswordVisible
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                : null),
                                      ),
                                      fillColor:
                                          getFillColor(_newPasswordFocusNode),
                                      hintText: 'New password'),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                  textInputAction: TextInputAction.done,
                                  key: _confirmKey,
                                  validator: (repassword) =>
                                      repassword!.isEmpty == true
                                          ? "password cannot be empty"
                                          : repassword !=
                                                  _newPasswordController.text
                                                      .toString()
                                              ? "passwords do not match"
                                              : null,
                                  controller: _confirmPasswordController,
                                  focusNode: _confirmPasswordFocusNode,
                                  decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _isConfirmPasswordVisible =
                                                !_isConfirmPasswordVisible;
                                          });
                                        },
                                        icon: Icon(Icons.visibility,
                                            color: _isConfirmPasswordVisible
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                : null),
                                      ),
                                      fillColor: getFillColor(
                                          _confirmPasswordFocusNode),
                                      hintText: 'Confirm password'),
                                ),
                              ]),
                        )),
                    SizedBox(
                      height: 40,
                    ),
                    Spacer(),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: ElevatedButton(
                          onPressed: clockUserProvider.verifyingStatus == 3
                              ? setNewPassword
                              : null,
                          child: Text('Reset'),
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 48)),
                        )),
                    Spacer()
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  void setNewPassword() async {
    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    ClockUserProvider clockUserProvider =
        Provider.of<ClockUserProvider>(context, listen: false);

    final String password = _newPasswordController.text.toString();
    final String mail = _emailController.text.toString();

    if (_newMailKey.currentState?.validate() == true &&
        _confirmKey.currentState?.validate() == true) {
      String? response = await userRepository.resetUserPassword(
          email: mail, updatedPassword: password, context: context);
      if (response == "done") {
        Get.offAll(() => LoginScreen());
        clockUserProvider.updateVerifyingStatus(updatedStatus: 1);
      }
    }
    _newPasswordController.clear();
    _confirmPasswordController.clear();
  }
}
