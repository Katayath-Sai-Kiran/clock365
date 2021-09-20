import 'dart:convert';

import 'package:clock365/repository/userRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:clock365/constants.dart';
import 'package:provider/provider.dart';

class OrganizationRepository extends ChangeNotifier {
  final Map<String, String> headers = {
    "Content-Type": "application/json",
  };
  Future registerOrganization({
    required Map data,
    required String oId,
    required BuildContext context,
  }) async {
    final UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    try {
      final Uri uri = Uri.parse(kUserOrganizationResisterEndpoint);
      final String encodedData = jsonEncode(data);
      http.Response response =
          await http.post(uri, headers: headers, body: encodedData);
      if (response.statusCode == 201) {
        Map organizationData = jsonDecode(response.body);
        Box users = await Hive.openBox<Map>(kUserBox);
        Map updatedUserData = users.get(oId);
        updatedUserData.update(
            "organizations", (value) => [organizationData, ...value]);
        await users.put(oId, updatedUserData);

        userRepository.updateOwner(
            updatedOrganizations: updatedUserData["organizations"]);

        return "done";
      } else {
        Map messsage = response.body as Map;
        return messsage["msg"];
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
