import 'dart:async';

import 'package:clock365/constants.dart';
import 'package:clock365/customWidgets.dart';
import 'package:clock365/repository/userRepository.dart';
import 'package:clock365/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';

class OTPBottomSheet extends StatefulWidget {
  final String? mail;
  final String? jobTitle;
  OTPBottomSheet({this.mail, this.jobTitle});

  @override
  _OTPBottomSheetState createState() => _OTPBottomSheetState();
}

class _OTPBottomSheetState extends State<OTPBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OTPHeader(
            jobTitle: widget.jobTitle.toString(),
            mail: widget.mail.toString(),
          ),
          // Padding(
          //   padding: EdgeInsets.all(16),
          //   child: OTPBody(
          //     mail: widget.mail,
          //     jobTitle: widget.jobTitle,
          //   ),
          // )
        ],
      ),
    );
  }
}

class OTPHeader extends StatefulWidget {
  final String mail;
  final String jobTitle;
  OTPHeader({required this.jobTitle, required this.mail});
  @override
  _OTPHeaderState createState() => _OTPHeaderState();
}

class _OTPHeaderState extends State<OTPHeader> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      timerdelay();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  late Timer _timer;
  String? _otp;
  final CustomWidgets _customWidgets = CustomWidgets();
  bool _isTimeOut = false;
  int timer = 30;

  void timerdelay() {
    _timer = Timer.periodic(Duration(seconds: 1), (timerObject) {
      setState(() {
        if (timer > 0) {
          timer = timer - 1;
        } else {
          _isTimeOut = true;
          _timer.cancel();
        }
      });
    });
  }

  bool _isSubmitLoading = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final UserRepository userrepository =
        Provider.of<UserRepository>(context, listen: false);

    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: kStrokeColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Resend OTP',
                style: themeData.textTheme.headline5,
              ),
              SizedBox(
                height: 8,
              ),
              RichText(
                text: TextSpan(
                    text: 'Waiting time ',
                    style: themeData.textTheme.bodyText2,
                    children: <InlineSpan>[
                      TextSpan(
                        text: '0:$timer',
                        style: themeData.textTheme.bodyText2
                            ?.copyWith(color: themeData.colorScheme.primary),
                      ),
                    ]),
              ),
              SizedBox(
                height: 8,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  OTPTextField(
                    onCompleted: (string) {
                      setState(() {
                        _otp = string;
                      });
                    },
                    keyboardType: TextInputType.number,
                    length: 4,
                    width: double.infinity,
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldWidth: 56,
                    fieldStyle: FieldStyle.underline,
                    otpFieldStyle: OtpFieldStyle(),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text('Please enter the 4 digit code we sent to your mail'),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 48),
                    child: ElevatedButton(
                      onPressed: _isTimeOut
                          ? () async {
                              setState(() {
                                _isTimeOut = false;
                                timer = 30;
                              });
                              timerdelay();
                            }
                          : null,
                      child: Text('Resend'),
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16)),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 48),
                    child: _isSubmitLoading
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                _isSubmitLoading = true;
                              });
                              String? response =
                                  await userrepository.verifyUserGmail(
                                context: context,
                                jobTitle: widget.jobTitle.toString(),
                                otpCode: _otp.toString(),
                                mail: widget.mail.toString(),
                              );

                              if (response == "done") {
                                _customWidgets.successToste(
                                    text: "Email verified successfully",
                                    context: context);

                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  kSignupIntroduce,
                                  (route) => false,
                                  arguments: {
                                    "mail": widget.mail,
                                    "job_title": widget.jobTitle,
                                  },
                                );
                              } else {
                                setState(() {
                                  _isSubmitLoading = false;
                                });
                              }
                            },
                            child: Text('Submit'),
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 16)),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

// class OTPBody extends StatefulWidget {
//   final String? mail;
//   final String? jobTitle;
//   const OTPBody({this.mail, this.jobTitle});

//   @override
//   _OTPBodyState createState() => _OTPBodyState();
// }

// class _OTPBodyState extends State<OTPBody> {
//   String? _otp;
//   final CustomWidgets _customWidgets = CustomWidgets();
//   bool _isTimeOut = false;

//   @override
//   Widget build(BuildContext context) {
//     final UserRepository userrepository =
//         Provider.of<UserRepository>(context, listen: false);
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         SizedBox(
//           height: 8,
//         ),
//         OTPTextField(
//           onCompleted: (string) {
//             setState(() {
//               _otp = string;
//             });
//           },
//           keyboardType: TextInputType.number,
//           length: 4,
//           width: double.infinity,
//           textFieldAlignment: MainAxisAlignment.spaceAround,
//           fieldWidth: 56,
//           fieldStyle: FieldStyle.underline,
//         ),
//         SizedBox(
//           height: 16,
//         ),
//         Text('Please enter the 4 digit code we sent to your mail'),
//         SizedBox(
//           height: 16,
//         ),
//         Padding(
//           padding: EdgeInsets.symmetric(vertical: 0, horizontal: 48),
//           child: ElevatedButton(
//             onPressed: _isTimeOut ? () async {} : null,
//             child: Text('Resend'),
//             style: ElevatedButton.styleFrom(
//                 padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16)),
//           ),
//         ),
//         SizedBox(
//           height: 16,
//         ),
//         Padding(
//           padding: EdgeInsets.symmetric(vertical: 8, horizontal: 48),
//           child: ElevatedButton(
//             onPressed: () async {
//               String? response = await userrepository.verifyUserGmail(
//                 context: context,
//                 jobTitle: widget.jobTitle.toString(),
//                 otpCode: _otp.toString(),
//                 mail: widget.mail.toString(),
//               );

//               if (response == "done") {
//                 _customWidgets.successToste(
//                     text: "Email verified successfully", context: context);

//                 Navigator.of(context).pushNamedAndRemoveUntil(
//                   kSignupIntroduce,
//                   (route) => false,
//                   arguments: {
//                     "mail": widget.mail,
//                     "job_title": widget.jobTitle,
//                   },
//                 );
//               }
//             },
//             child: Text('Submit'),
//             style: ElevatedButton.styleFrom(
//                 padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16)),
//           ),
//         ),
//       ],
//     );
//   }
// }
