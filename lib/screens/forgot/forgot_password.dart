import 'package:clock365/elements/semi_circle.dart';
import 'package:clock365/screens/login/login_screen.dart';
import 'package:clock365/screens/signup/otp_bottom_sheet.dart';
import 'package:clock365/theme/colors.dart';
import 'package:flutter/material.dart';

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

  bool _isVerified = false;

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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextFormField(
                                        validator: (email) =>
                                            email!.isEmpty == true
                                                ? "Email is badly formated"
                                                : null,
                                        controller: _emailController,
                                        focusNode: _emailFocusNode,
                                        decoration: InputDecoration(
                                            hintText: 'Email',
                                            fillColor:
                                                getFillColor(_emailFocusNode)),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          child: Text('Verify'),
                                          onPressed: () {
                                            showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .scaffoldBackgroundColor,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(24),
                                                            topRight:
                                                                Radius.circular(
                                                                    24))),
                                                builder: (context) {
                                                  return OTPBottomSheet(
                                                      mail: "", jobTitle: "");
                                                });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      TextFormField(
                                        textInputAction: TextInputAction.next,
                                        obscureText: _isPasswordVisible,
                                        validator: (password) =>
                                            password!.isEmpty
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
                                            fillColor: getFillColor(
                                                _newPasswordFocusNode),
                                            hintText: 'New password'),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      TextFormField(
                                        validator: (repassword) =>
                                            repassword!.isEmpty == true
                                                ? "password cannot be empty"
                                                : repassword ==
                                                        _newPasswordController
                                                            .text
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
                                                  color:
                                                      _isConfirmPasswordVisible
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
                                onPressed: !_isVerified
                                    ? null
                                    : () {
                                        if (_formKey.currentState!.validate())
                                          showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              backgroundColor: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  24),
                                                          topRight:
                                                              Radius.circular(
                                                                  24))),
                                              builder: (context) =>
                                                  LoginScreen());
                                      },
                                child: Text('Reset'),
                                style: ElevatedButton.styleFrom(
                                    minimumSize: Size(double.infinity, 48)),
                              )),
                          Spacer()
                        ],
                      ))))),
    );
  }
}
