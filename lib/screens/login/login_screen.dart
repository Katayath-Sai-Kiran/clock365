import 'package:clock365/constants.dart';
import 'package:clock365/elements/semi_circle.dart';
import 'package:clock365/theme/colors.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _loginTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  final FocusNode _loginFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isStaffLogin = true;

  Color getFillColor(FocusNode focusNode) =>
      focusNode.hasFocus ? Colors.white : kStrokeColor;

  @override
  void initState() {
    super.initState();
    _loginFocusNode.addListener(onFocusChange);
    _passwordFocusNode.addListener(onFocusChange);
  }

  void onFocusChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Scaffold(
        body: Center(
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
                'Hello\nPlease Login',
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    ?.copyWith(fontWeight: FontWeight.w800),
              )),
          SizedBox(
            height: 8,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _isStaffLogin = true;
                        });
                      },
                      child: Text(
                        'I am Staff',
                        style: themeData.textTheme.button?.copyWith(
                            color: _isStaffLogin
                                ? themeData.colorScheme.primary
                                : kStrokeColor),
                      )),
                  Text(' / '),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _isStaffLogin = false;
                        });
                      },
                      child: Text(
                        'I am Visitor',
                        style: themeData.textTheme.button?.copyWith(
                            color: !_isStaffLogin
                                ? themeData.colorScheme.primary
                                : kStrokeColor),
                      ))
                ],
              )),
          SizedBox(
            height: 16,
          ),
          Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _loginTextEditingController,
                      focusNode: _loginFocusNode,
                      decoration: InputDecoration(
                          hintText: 'Attendance login',
                          fillColor: getFillColor(_loginFocusNode)),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextField(
                      controller: _passwordTextEditingController,
                      focusNode: _passwordFocusNode,
                      decoration: InputDecoration(
                          fillColor: getFillColor(_passwordFocusNode),
                          hintText: 'Password'),
                    ),
                    TextButton(
                        onPressed: () => Navigator.of(context)
                            .pushNamed(kForgotPasswordRoute),
                        child: Text('Forgot password?')),
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: ElevatedButton(
                          onPressed: () => {
                            Navigator.of(context).pushReplacementNamed(
                                kLocationModificationRoute)
                          },
                          child: Text('Login'),
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 48)),
                        )),
                    SizedBox(
                      height: 24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('New here?'),
                        TextButton(
                            onPressed: () =>
                                {Navigator.of(context).pushNamed(kSignupRoute)},
                            child: Text('Sign up'))
                      ],
                    ),
                  ]))
        ],
      )),
    ));
  }
}
