import 'package:clock365/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class CapturePhotoScreen extends StatefulWidget {
  const CapturePhotoScreen({Key? key}) : super(key: key);

  @override
  _CapturePhotoScreenState createState() => _CapturePhotoScreenState();
}

class _CapturePhotoScreenState extends State<CapturePhotoScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  @override
  Widget build(BuildContext context) {
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
                          children: [
                            Padding(
                                padding: EdgeInsets.only(bottom: 24),
                                child: ClipRRect(
                                    child: Image.asset(
                                        'assets/sample_capture.png'))),
                            Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: IconButton(
                                    onPressed: () async {
                                      final XFile? image =
                                          await _imagePicker.pickImage(
                                              source: ImageSource.gallery);
                                    },
                                    icon: SizedBox(
                                      height: 48,
                                      width: 48,
                                      child: SvgPicture.asset(
                                          'assets/retake_photo.svg'),
                                    ))),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'John Doe',
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Container(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          onPressed: () => {},
                          child: Text(
                            S.of(context).confirmSignIn,
                            style: Theme.of(context).textTheme.button?.copyWith(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor),
                          ),
                        ))
                  ],
                ))));
  }
}
