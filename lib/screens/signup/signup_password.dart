import 'package:clock365/customWidgets.dart';
import 'package:clock365/elements/semi_circle.dart';
import 'package:clock365/providers/user_provider.dart';
import 'package:clock365/repository/userRepository.dart';
import 'package:clock365/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupPasswordScreen extends StatefulWidget {
  const SignupPasswordScreen({Key? key}) : super(key: key);

  @override
  _SignupPasswordScreenState createState() => _SignupPasswordScreenState();
}

class _SignupPasswordScreenState extends State<SignupPasswordScreen> {
  final CustomWidgets _customWidgets = CustomWidgets();
  final TextEditingController _createPasswordController =
      TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FocusNode _createPasswordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  final GlobalKey<FormFieldState> _confirmPasswordKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _createPasswordKey =
      GlobalKey<FormFieldState>();

  Map userData = {};

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
    userData = ModalRoute.of(context)?.settings.arguments as Map;

    return Consumer<ClockUserProvider>(
      builder: (context, ClockUserProvider accountProvider, child) {
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
                                    'Hello\n${userData["name"]}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        ?.copyWith(fontWeight: FontWeight.w800),
                                  )),
                              Padding(
                                  padding: EdgeInsets.all(24),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          textInputAction: TextInputAction.next,
                                          validator: (val) => val!.isEmpty
                                              ? "password cannot be empty"
                                              : null,
                                          onFieldSubmitted: (val) {
                                            _createPasswordKey.currentState
                                                ?.validate();
                                          },
                                          key: _createPasswordKey,
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
                                        TextFormField(
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          validator: (val) => val !=
                                                  _createPasswordController.text
                                                      .toString()
                                              ? "passwords do not match"
                                              : null,
                                          key: _confirmPasswordKey,
                                          onFieldSubmitted: (val) {
                                            _confirmPasswordKey.currentState
                                                ?.validate();
                                          },
                                          controller:
                                              _confirmPasswordController,
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
                                    onPressed: signUp,
                                    child: Text('Next'),
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: Size(double.infinity, 48)),
                                  )),
                              Spacer()
                            ],
                          ))))),
        );
      },
    );
  }

  void signUp() async {
    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);

    final String password = _createPasswordController.text.toString();
    final String confirmPassword = _confirmPasswordController.text.toString();

    if (_createPasswordKey.currentState?.validate() == true &&
        _confirmPasswordKey.currentState?.validate() == true &&
        password == confirmPassword) {

      String? response = await userRepository.signUpClockUser(
        context: context,
        password: password,
        data: userData,
      );
      if (response == "done") {
        _customWidgets.successToste(
            text: "Successfully signed up", context: context);
        _createPasswordController.clear();
        _confirmPasswordController.clear();
      }

      _createPasswordController.clear();
      _confirmPasswordController.clear();
    }
  }
}
