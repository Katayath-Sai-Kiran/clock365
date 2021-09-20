import 'package:clock365/constants.dart';
import 'package:clock365/generated/l10n.dart';
import 'package:clock365/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VisitorSignInDetailsScreen extends StatefulWidget {
  const VisitorSignInDetailsScreen({Key? key}) : super(key: key);

  @override
  _UserSignInScreenState createState() => _UserSignInScreenState();
}

class _UserSignInScreenState extends State<VisitorSignInDetailsScreen> {
  final TextEditingController _orgNameController = TextEditingController();
  final FocusNode _yourNameFocusNode = FocusNode();
  final FocusNode _orgNameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _yourNameFocusNode.addListener(onFocusChange);
    _orgNameFocusNode.addListener(onFocusChange);
  }

  void onFocusChange() {
    setState(() {});
  }

  Color getFillColor(FocusNode focusNode) =>
      focusNode.hasFocus ? Colors.white : kStrokeColor;

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
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    TextField(
                      controller: _orgNameController,
                      focusNode: _orgNameFocusNode,
                      decoration: InputDecoration(
                          fillColor: getFillColor(_orgNameFocusNode),
                          hintText: S.of(context).yourOrgName),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextButton(
                        onPressed: () => {},
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              S.of(context).informationBeingUsedConsent,
                              style: Theme.of(context).textTheme.bodyText2,
                            )),
                            CupertinoSwitch(
                                value: true, onChanged: (newState) => {})
                          ],
                        ))
                  ],
                ),
                Container(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: () => {
                        Navigator.of(context)
                            .pushNamed(kUserConfirmSignInScreen)
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
