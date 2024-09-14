import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:zcart_delivery/helper/constants.dart';
import 'package:zcart_delivery/network/api.dart';

const _noInternetMsg = 'You are not connected to Internet';
//const _errorMsg = 'Please try again later.';

Future<bool> _isNetworkAvailable() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult != ConnectivityResult.none;
}

String getAccessToken() {
  var _box = Hive.box(hiveBox);
  return _box.get(access, defaultValue: '');
}

Future<void> setAccessToken(String token) async {
  var _box = Hive.box(hiveBox);
  await _box.put(access, token);
}

bool isRequestSuccessful(int code) {
  return code >= 200 && code <= 206;
}

class NetworkHelper {
  /// Variables
  bool accessAllowed = false;

  static Future<Response?> getRequest(String endPoint,
      {bool bearerToken = false, Map<String, dynamic>? requestBody}) async {
    if (await _isNetworkAvailable()) {
      Map<String, String>? _headers;
      Response? _response;

      var _accessToken = getAccessToken();

      if (bearerToken) {
        _headers = {
          HttpHeaders.acceptHeader: 'application/json; charset=utf-8',
          'Authorization': 'Bearer $_accessToken',
        };
      }

      try {
        final _uri = requestBody == null
            ? Uri.parse('${API.base}$endPoint')
            : Uri.https(API.base.substring(8).split("/").first,
                "api/" + endPoint, requestBody);

        debugPrint('URL: $_uri');
        debugPrint('QueryParams: ${_uri.queryParameters}');

        if (bearerToken) {
          _response = await get(_uri, headers: _headers);
        } else {
          _response = await get(_uri);
        }
      } catch (e) {
        debugPrint(e.toString());
      }

      return _response;
    } else {
      throw _noInternetMsg;
    }
  }

  static Future<Response?> postRequest(String endPoint, Map requestBody,
      {bool bearerToken = false}) async {
    if (await _isNetworkAvailable()) {
      Response? _response;

      debugPrint('URL: ${API.base}$endPoint');
      debugPrint('body: $requestBody');

      var _accessToken = getAccessToken();

      var _headers = {
        HttpHeaders.acceptHeader: 'application/json; charset=utf-8',
      };

      if (bearerToken) {
        var _header = {
          'Authorization': 'Bearer $_accessToken',
        };
        _headers.addAll(_header);
      }

      debugPrint("Headers: $_headers");
      try {
        _response = await post(Uri.parse('${API.base}$endPoint'),
            body: requestBody, headers: _headers);
      } catch (e) {
        debugPrint(e.toString());
      }

      return _response;
    } else {
      throw _noInternetMsg;
    }
  }

  static Future<Response?> putRequest(String endPoint, Map request,
      {bool bearerToken = true}) async {
    if (await _isNetworkAvailable()) {
      Response? _response;
      debugPrint('URL: ${API.base}$endPoint');
      debugPrint('Request: $request');

      var _accessToken = getAccessToken();

      var _headers = {
        HttpHeaders.acceptHeader: 'application/json; charset=utf-8',
      };

      if (bearerToken) {
        var _header = {"Authorization": "Bearer $_accessToken"};
        _headers.addAll(_header);
      }

      debugPrint("Headers: $_headers");

      try {
        _response = await put(Uri.parse('${API.base}$endPoint'),
            body: request, headers: _headers);
      } catch (e) {
        debugPrint(e.toString());
      }
      debugPrint('Response: ${_response?.statusCode} ${_response?.body}');
      return _response;
    } else {
      throw _noInternetMsg;
    }
  }

  // patchRequest(String endPoint, Map request,
  //     {bool requireToken = false,
  //     bool bearerToken = false,
  //     bool isDigitToken = false}) {}

  static Future<Response?> deleteRequest(String endPoint,
      {bool bearerToken = true}) async {
    if (await _isNetworkAvailable()) {
      var _accessToken = getAccessToken();

      var _headers = {
        HttpHeaders.acceptHeader: 'application/json; charset=utf-8',
      };

      if (bearerToken) {
        var _header = {"Authorization": "Bearer $_accessToken"};
        _headers.addAll(_header);
      }

      debugPrint(_headers.toString());
      Response _response =
          await delete(Uri.parse('${API.base}$endPoint'), headers: _headers);
      debugPrint('Response: ${_response.statusCode} ${_response.body}');

      return _response;
    } else {
      throw _noInternetMsg;
    }
  }
}

dynamic handleResponse(Response response, {bool showToast = true}) {
  if (isRequestSuccessful(response.statusCode)) {
    if (response.body.isNotEmpty) {
      debugPrint(response.statusCode.toString());
      debugPrint(response.body);
      return jsonDecode(response.body);
    } else {
      return response.body;
    }
  } else {
    debugPrint("handleResponse (json): ${jsonDecode(response.body)}");
    if (jsonDecode(response.body)['errors'] != null) {
      Fluttertoast.showToast(
          msg: jsonDecode(response.body)['errors']
              [jsonDecode(response.body)['errors'].keys.first][0]);
    } else if (showToast) {
      Fluttertoast.showToast(
          msg: jsonDecode(response.body)['message'] ??
              jsonDecode(response.body)['error']);
    }

    if (response.statusCode == 401) {
      setAccessToken('');
    }

    return response.statusCode;
  }
}
