import 'package:clock365/constants.dart';
import 'package:clock365/elements/semi_circle.dart';
import 'package:clock365/repository/userRepository.dart';
import 'package:clock365/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  final GlobalKey<FormFieldState> _loginMailKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _loginPasswordKey =
      GlobalKey<FormFieldState>();

  bool _isStaffLogin = true;
  bool _isVisible = false;

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
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      key: _loginMailKey,
                      onFieldSubmitted: (val) {
                        _loginMailKey.currentState?.validate();
                      },
                      validator: (val) {
                        if (val?.isEmpty == true ||
                            val?.contains("@") == false) {
                          return "Please enter a valid email";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      controller: _loginTextEditingController,
                      focusNode: _loginFocusNode,
                      decoration: InputDecoration(
                          hintText: 'Attendance login',
                          fillColor: getFillColor(_loginFocusNode)),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      onFieldSubmitted: (val) {
                        _loginPasswordKey.currentState?.validate();
                      },
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      validator: (val) => val?.isEmpty == true
                          ? "Password cannot be empty"
                          : null,
                      key: _loginPasswordKey,
                      controller: _passwordTextEditingController,
                      focusNode: _passwordFocusNode,
                      obscureText: _isVisible ? false : true,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isVisible = !_isVisible;
                            });
                          },
                          icon: Icon(
                            _isVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                        fillColor: getFillColor(_passwordFocusNode),
                        hintText: 'Password',
                      ),
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
                          onPressed: login,
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

  Future login() async {
    final UserRepository userRepository = Provider.of(context, listen: false);
    final String mail = _loginTextEditingController.text.toString();
    final String password = _passwordTextEditingController.text.toString();

    if (_loginMailKey.currentState?.validate() == true &&
        _loginPasswordKey.currentState?.validate() == true) {
      String? responce = await userRepository.login(
        email: mail,
        password: password,
        signInType: _isStaffLogin ? 1 : 2,
        context: context,
      );

      if (responce == "done") {
        _loginTextEditingController.clear();
        _passwordTextEditingController.clear();
      } else {
        _loginTextEditingController.clear();
        _passwordTextEditingController.clear();
      }
    }
  }
}
