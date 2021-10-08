import 'dart:io';

import 'package:clock365/constants.dart';
import 'package:clock365/generated/l10n.dart';
import 'package:clock365/models/clock_user.dart';
import 'package:clock365/repository/userRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:clock365/models/OrganizationModel.dart';

class CaptureVisitorPhoto extends StatefulWidget {
  final OrganizationModel? selectedOrganization;
  CaptureVisitorPhoto({required this.selectedOrganization});
  @override
  State<CaptureVisitorPhoto> createState() => _CaptureVisitorPhotoState();
}

class _CaptureVisitorPhotoState extends State<CaptureVisitorPhoto> {
  final ImagePicker _imagePicker = ImagePicker();

  File? _capturedImage;
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final ClockUser currentUser = Hive.box(kUserBox).get(kCurrentUserKey);
    final UserRepository userRepository = Provider.of(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).signIn),
        ),
        body: SafeArea(
            child: Padding(
                padding: EdgeInsets.all(24),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          fit: StackFit.loose,
                          children: [
                            Center(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 24),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: _capturedImage == null
                                      ? Icon(
                                          Icons.account_circle_rounded,
                                          size: _width * 0.85,
                                        )
                                      : Image.file(_capturedImage!),
                                ),
                              ),
                            ),
                            Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: IconButton(
                                    onPressed: () async {
                                      XFile? _image =
                                          await _imagePicker.pickImage(
                                              source: ImageSource.gallery);
                                      setState(() {
                                        _capturedImage = File(_image!.path);
                                      });
                                    },
                                    icon: SizedBox(
                                      height: 64,
                                      width: 64,
                                      child: SvgPicture.asset(
                                          'assets/retake_photo.svg'),
                                    ))),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          currentUser.name!,
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Container(
                        alignment: Alignment.bottomCenter,
                        child: _isSigningIn
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : ElevatedButton(
                                onPressed: () async {
                                  if (_capturedImage == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        margin: EdgeInsets.all(16.0),
                                        content: Row(
                                          children: [
                                            Icon(Icons.warning_amber_outlined,
                                                color: Colors.orange),
                                            SizedBox(
                                              width: 16.0,
                                            ),
                                            Flexible(
                                              child: Text(
                                                  "Please select an image"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    setState(() {
                                      _isSigningIn = true;
                                    });
                                    userRepository.manualSignInUser(
                                      context: context,
                                      organizationName: widget
                                          .selectedOrganization!
                                          .organizationName!,
                                      profileImage: _capturedImage!,
                                      signInType: 2,
                                      userId: currentUser.id!,
                                    );
                                    setState(() {
                                      _isSigningIn = false;
                                    });
                                  }
                                },
                                child: Text(
                                  S.of(context).confirmSignIn,
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      ?.copyWith(
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor),
                                ),
                              ))
                  ],
                ))));
  }
}
