import 'package:clock365/constants.dart';
import 'package:clock365/models/clock_user.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserNotifier extends ChangeNotifier {

  ClockUser? get currentUser => Hive.box<ClockUser>(kClockUserBox).get(kUserKey, defaultValue: null);

  
}
