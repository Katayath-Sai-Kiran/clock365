import 'package:clock365/constants.dart';
import 'package:clock365/generated/l10n.dart';
import 'package:flutter/material.dart';

class UserConfirmSignInScreen extends StatefulWidget {
  const UserConfirmSignInScreen({Key? key}) : super(key: key);

  @override
  _UserConfirmSignInScreenState createState() =>
      _UserConfirmSignInScreenState();
}

class _UserConfirmSignInScreenState extends State<UserConfirmSignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).signInDetails),
      ),
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.all(24),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe',
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text('Ultra Tech Technology Pvt. Ltd.')
                  ],
                ),
                Container(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: () => {
                        Navigator.of(context).pushNamed(kCapturePhotoScreen)
                      },
                      child: Text(
                        S.of(context).actionContinue,
                        style: Theme.of(context).textTheme.button?.copyWith(
                            color: Theme.of(context).scaffoldBackgroundColor),
                      ),
                    ))
              ],
            )),
      ),
    );
  }
}
