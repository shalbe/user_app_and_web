import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zcart_delivery/models/vendor_mode.dart';
import 'package:zcart_delivery/network/api.dart';
import 'package:zcart_delivery/network/network_helper.dart';
import 'package:zcart_delivery/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

final vendorProvider = FutureProvider<VendorModel?>((ref) async {
  try {
    final _response =
        await NetworkHelper.getRequest(API.vendor, bearerToken: true);

    if (_response != null) {
      debugPrint(_response.body);
      if (isRequestSuccessful(_response.statusCode)) {
        final _vendor =
            VendorModel.fromJson(json.decode(_response.body)["data"]);
        return _vendor;
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
