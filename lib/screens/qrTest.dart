import 'dart:developer';
import 'dart:io';

import 'package:clock365/constants.dart';
import 'package:clock365/customWidgets.dart';
import 'package:clock365/models/clock_user.dart';
import 'package:clock365/models/organization.dart';
import 'package:clock365/repository/organization_repository.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:clock365/models/OrganizationModel.dart';

class QRViewExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final CustomWidgets _customWidgets = CustomWidgets();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool? _isFlash = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _height = MediaQuery.of(context).size.height;
    final double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Container(
            height: _height * 0.1,
            width: _width * 0.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    setState(() {
                      controller!.flipCamera();
                    });
                  },
                  icon: Icon(
                    Platform.isAndroid
                        ? Icons.flip_camera_android_outlined
                        : Icons.flip_camera_ios_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    setState(() {
                      controller!.toggleFlash();
                      if (_isFlash == true) {
                        _isFlash = false;
                      } else {
                        _isFlash = true;
                      }
                    });
                  },
                  icon: Icon(
                    _isFlash == false
                        ? Icons.flash_on_outlined
                        : Icons.flash_off_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Theme.of(context).colorScheme.primary,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: 250.0),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) async {
    ClockUser currentUser = Hive.box(kUserBox).get(kCurrentUserKey);
    OrganizationRepository organizationRepository =
        Provider.of<OrganizationRepository>(context, listen: false);

    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
        print(result!.code);
        this.controller!.stopCamera();
      });
      OrganizationModel scannedOrganization = await organizationRepository
          .getScannedOrganizationDetails(context: context, orgId: result!.code);

      List<ClockUser>? staff = scannedOrganization.staff;

      bool _isCurrentOrgStaff =
          staff!.any((element) => element.id == currentUser.id);

      int signInType = Hive.box(kUserBox).get(kSignInType);
      bool isStaff = signInType == 1 ? true : false;
      if (isStaff) {
        if (_isCurrentOrgStaff) {
          //user available
          // Navigator.of(context).pop();

          _customWidgets.successToste(
              text:
                  "successfully signIn into ${currentUser.currentOrganization!.organizationName}",
              context: context);
        } else {
          //not available
          // Navigator.of(context).pop();

          _customWidgets.failureToste(
              text:
                  "You are not registered with ${currentUser.currentOrganization!.organizationName}",
              context: context);
        }
      } else {
        if (scannedOrganization.visitorSignIn == true) {
          _customWidgets.successToste(
              text:
                  "Successfully Signed Into ${scannedOrganization.organizationName}",
              context: context);
        } else {
          _customWidgets.failureToste(
              text:
                  "Visitors cannot signIn into ${scannedOrganization.organizationName}",
              context: context);
        }
      }
    });
    //  check for user is available in curretn org staff
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }
}
