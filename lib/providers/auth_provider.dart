import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zcart_delivery/models/user_model.dart';
import 'package:zcart_delivery/network/api.dart';
import 'package:zcart_delivery/network/network_helper.dart';
import 'package:zcart_delivery/translations/locale_keys.g.dart';

final userProvider = FutureProvider<UserModel?>((ref) async {
  try {
    final _response =
        await NetworkHelper.getRequest(API.profile, bearerToken: true);

    if (_response != null) {
      debugPrint(_response.body);
      if (isRequestSuccessful(_response.statusCode)) {
        final _user = UserModel.fromJson(json.decode(_response.body)["data"]);
        return _user;
      } else if (_response.statusCode == 401) {
        Fluttertoast.showToast(msg: LocaleKeys.you_are_not_logged_in.tr());

        return null;
      } else {
        Fluttertoast.showToast(
            msg: jsonDecode(_response.body)['message'] ??
                LocaleKeys.something_went_wrong.tr());
        return null;
      }
    } else {
      Fluttertoast.showToast(msg: LocaleKeys.something_went_wrong.tr());
      return null;
    }
  } catch (e) {
    Fluttertoast.showToast(msg: e.toString());
    return null;
  }
});

class AuthController {
  static Future<UserModel?> login(String email, String password) async {
    Map<String, String> _requestBody = {
      'email': email,
      'password': password,
    };

    try {
      final _response =
          await NetworkHelper.postRequest(API.login, _requestBody);

      if (_response != null) {
        debugPrint(_response.body);
        if (isRequestSuccessful(_response.statusCode)) {
          Fluttertoast.showToast(msg: LocaleKeys.login_success.tr());

          return UserModel.fromJson(jsonDecode(_response.body)['data']);
        } else {
          Fluttertoast.showToast(
              msg: jsonDecode(_response.body)['message'] ??
                  LocaleKeys.something_went_wrong.tr());
          return null;
        }
      } else {
        Fluttertoast.showToast(msg: LocaleKeys.something_went_wrong.tr());
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return null;
    }
  }

  static Future<bool> logout() async {
    try {
      final _response =
          await NetworkHelper.postRequest(API.logout, {}, bearerToken: true);

      if (_response != null) {
        debugPrint(_response.body);
        if (isRequestSuccessful(_response.statusCode)) {
          Fluttertoast.showToast(msg: LocaleKeys.logout_success.tr());
          await setAccessToken('');
          return true;
        } else {
          Fluttertoast.showToast(
              msg: jsonDecode(_response.body)['message'] ??
                  LocaleKeys.something_went_wrong.tr());
          return false;
        }
      } else {
        Fluttertoast.showToast(msg: LocaleKeys.something_went_wrong.tr());
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return false;
    }
  }

  static Future<bool> updateProfile(UserModel user) async {
    try {
      final _response = await NetworkHelper.postRequest(
          API.profile, user.toJson(),
          bearerToken: true);

      if (_response != null) {
        debugPrint(_response.body);
        if (isRequestSuccessful(_response.statusCode)) {
          return true;
        } else {
          Fluttertoast.showToast(
              msg: jsonDecode(_response.body)['message'] ??
                  LocaleKeys.something_went_wrong.tr());

          return false;
        }
      } else {
        Fluttertoast.showToast(msg: LocaleKeys.something_went_wrong.tr());
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return false;
    }
  }

  static Future<bool> updatePassword(String oldPass, String newPass) async {
    Map<String, String> _requestBody = {
      'oldpassword': oldPass,
      'newpassword': newPass,
    };
    try {
      final _response = await NetworkHelper.postRequest(
          API.updatePassword, _requestBody,
          bearerToken: true);

      if (_response != null) {
        debugPrint(_response.body);
        if (isRequestSuccessful(_response.statusCode)) {
          if (jsonDecode(_response.body)['isSuccess'] == true) {
            Fluttertoast.showToast(msg: jsonDecode(_response.body)['message']);
          }
          return jsonDecode(_response.body)['isSuccess'] ?? false;
        } else {
          Fluttertoast.showToast(
              msg: jsonDecode(_response.body)['message'] ??
                  LocaleKeys.something_went_wrong.tr());

          return false;
        }
      } else {
        Fluttertoast.showToast(msg: LocaleKeys.something_went_wrong.tr());
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return false;
    }
  }

  static Future<bool> forgotPassword(String email) async {
    Map<String, String> _requestBody = {
      'email': email,
    };
    try {
      final _response =
          await NetworkHelper.postRequest(API.forgotPassword, _requestBody);

      if (_response != null) {
        debugPrint(_response.body);
        if (isRequestSuccessful(_response.statusCode)) {
          Fluttertoast.showToast(
              msg: jsonDecode(_response.body)['message'],
              toastLength: Toast.LENGTH_LONG);
          return true;
        } else {
          Fluttertoast.showToast(
              msg: jsonDecode(_response.body)['message'] ??
                  LocaleKeys.something_went_wrong.tr());

          return false;
        }
      } else {
        Fluttertoast.showToast(msg: LocaleKeys.something_went_wrong.tr());
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return false;
    }
  }

  static Future<bool> validateCode(String token) async {
    Map<String, String> _requestBody = {
      'token': token,
    };
    try {
      final _response = await NetworkHelper.getRequest(API.resetPassword,
          requestBody: _requestBody);

      if (_response != null) {
        debugPrint(_response.body);
        if (isRequestSuccessful(_response.statusCode)) {
          return true;
        } else {
          Fluttertoast.showToast(
              msg: jsonDecode(_response.body)['message'] ??
                  LocaleKeys.something_went_wrong.tr());

          return false;
        }
      } else {
        Fluttertoast.showToast(msg: LocaleKeys.something_went_wrong.tr());
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return false;
    }
  }

  static Future<bool> resetPassword(String password, String token) async {
    Map<String, String> _requestBody = {
      'password': password,
      'token': token,
    };
    try {
      final _response =
          await NetworkHelper.postRequest(API.resetPassword, _requestBody);

      if (_response != null) {
        debugPrint(_response.body);
        if (isRequestSuccessful(_response.statusCode)) {
          Fluttertoast.showToast(msg: jsonDecode(_response.body)['message']);
          return true;
        } else {
          Fluttertoast.showToast(
              msg: jsonDecode(_response.body)['message'] ??
                  LocaleKeys.something_went_wrong.tr());

          return false;
        }
      } else {
        Fluttertoast.showToast(msg: LocaleKeys.something_went_wrong.tr());
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return false;
    }
  }
}
