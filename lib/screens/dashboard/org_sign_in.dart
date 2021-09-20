import 'package:clock365/constants.dart';
import 'package:clock365/generated/l10n.dart';
import 'package:flutter/material.dart';

class OrganizationSignInScreen extends StatefulWidget {
  const OrganizationSignInScreen({Key? key}) : super(key: key);

  @override
  _OrganizationSignInScreenState createState() =>
      _OrganizationSignInScreenState();
}

class _OrganizationSignInScreenState extends State<OrganizationSignInScreen> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).signIn),
      ),
      body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextButton(
                  onPressed: () => {
                        Navigator.of(context)
                            .pushNamed(kUserSignInDetailsScreen)
                      },
                  child: SignInItem(
                      title: S.of(context).staff,
                      subtitle: S.of(context).xStaffSignIn('DLF Saket'),
                      color: themeData.colorScheme.primary)),
              TextButton(
                  onPressed: () => {
                        Navigator.of(context)
                            .pushNamed(kVisitorSignInDetailsScreen)
                      },
                  child: SignInItem(
                      title: S.of(context).visitor,
                      subtitle: S.of(context).visitorFromOtherCompanies,
                      color: themeData.colorScheme.secondary)),
            ],
          )),
    );
  }
}

class SignInItem extends StatelessWidget {
  final Color color;
  final String title;
  final String subtitle;
  const SignInItem(
      {Key? key,
      required this.color,
      required this.title,
      required this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(width: 2, color: color)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ],
              ),
            ),
            CircleAvatar(
              backgroundColor: color,
              radius: 24,
              child: Icon(Icons.arrow_forward_ios_rounded,
                  color: Theme.of(context).scaffoldBackgroundColor),
            )
          ],
        ));
  }
}
