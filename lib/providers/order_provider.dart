import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zcart_delivery/models/order_light_model.dart';
import 'package:zcart_delivery/network/api.dart';
import 'package:zcart_delivery/network/network_helper.dart';
import 'package:zcart_delivery/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:zcart_delivery/models/order_model.dart';

final ordersProvider = FutureProvider<List<OrderLightModel>?>((ref) async {
  try {
    final _response =
        await NetworkHelper.getRequest(API.orders, bearerToken: true);

    if (_response != null) {
      debugPrint(_response.body);
      if (isRequestSuccessful(_response.statusCode)) {
        List<OrderLightModel> _orders = [];

        for (var _order in jsonDecode(_response.body)['data']) {
          _orders.add(OrderLightModel.fromJson(_order));
        }

        return _orders;
      } else if (_response.statusCode == 401) {
        Fluttertoast.showToast(msg: LocaleKeys.you_are_not_logged_in.tr());

        return null;
      } else {
        Fluttertoast.showToast(
            msg: jsonDecode(_response.body)['message'] ??
                LocaleKeys.something_went_wrong.tr());
        return [];
      }
    } else {
      Fluttertoast.showToast(msg: LocaleKeys.something_went_wrong.tr());
      return [];
    }
  } catch (e) {
    Fluttertoast.showToast(msg: e.toString());
    return [];
  }
});

final orderProvider =
    FutureProvider.autoDispose.family<OrderModel?, int>((ref, orderId) async {
  try {
    final _response =
        await NetworkHelper.getRequest(API.order(orderId), bearerToken: true);

    if (_response != null) {
      debugPrint(_response.body);
      if (isRequestSuccessful(_response.statusCode)) {
        final _order = OrderModel.fromJson(jsonDecode(_response.body)['data']);

        return _order;
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

class OrderController {
  static Future<bool> updateStatus(int orderId, int status) async {
    try {
      final _response = await NetworkHelper.postRequest(
          API.updateStatus(orderId.toString()), {},
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

  static Future<bool> updatePaymentStatus(int orderId) async {
    // Map<String, String> _requestBody = {'payment_status': 1.toString()};

    try {
      final _response = await NetworkHelper.postRequest(
          API.updatePaymentStatus(orderId.toString()), {},
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
}
