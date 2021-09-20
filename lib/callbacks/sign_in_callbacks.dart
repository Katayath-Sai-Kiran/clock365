import 'dart:convert';

import 'package:http/http.dart' as http;

class SignUpCallbacks {
  final Map<String, String> headers = {
    "Content-Type": "application/json",
  };


  Future login({
    required String email,
    required String password,
    required int signInType,
  }) async {
    try {
      Uri url = Uri.parse("http://192.168.50.195:5000/api/v1/login");
      String body = jsonEncode({
        "email": email,
        "password": password,
        "signin_type": signInType,
      });
      http.Response responce = await http.post(
        url,
        body: body,
        headers: headers,
      );
      if (responce.statusCode == 200) {
        return "done";
      } else {
        return responce;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> signUp({
    required String? mail,
    required String? name,
    required String? password,
    required String? website,
    required String? organization,
    required String? jobTitle,
  }) async {
    String signUpUrl = "http://192.168.50.195:5000/api/v1/signup";
    try {
      String body = jsonEncode({
        "email": mail,
        "name": name,
        "password": password,
        "website": website,
        "job_title": jobTitle,
        "organizations": [organization],
      });
      http.Response response = await http.post(
        Uri.parse(signUpUrl),
        body: body,
        headers: headers,
      );
      if (response.statusCode == 200) {
        print("done");
        return "done";
      } else {
        print(response.body);
        return response.toString();
      }
    } catch (error) {
      return error.toString();
    }
  }

  Future generateOTP({required String? mail}) async {
    final String url =
        "http://192.168.50.195:5000/api/v1/send/code/verification";
    try {
      Uri uri = Uri.parse(url);
      var body = jsonEncode({
        "email": mail,
      });
      http.Response responce = await http.post(
        uri,
        body: body,
        headers: headers,
      );
      if (responce.statusCode == 200) {
        return "done";
      } else {
        return responce.statusCode.toString();
      }
    } catch (error) {
      print(error);
      return error.toString();
    }
  }

  Future verifyMail({
    required String? mail,
    required String? code,
  }) async {
    try {
      final Uri uri =
          Uri.parse("http://192.168.50.195:5000/api/v1/verify/code");
      final body = jsonEncode({"email": mail, "code": code});
      http.Response responce =
          await http.post(uri, body: body, headers: headers);
      if (responce.statusCode == 200) {
        return "done";
      } else {
        return responce;
      }
    } catch (e) {
      return e.toString();
    }
  }
}

//introduce -> password ->
