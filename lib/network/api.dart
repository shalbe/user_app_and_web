import 'package:zcart_delivery/config/config.dart';

class API {
  static String base = MyConfig.appApiUrl;

  static String login = "deliveryboy/login";
  static String logout = "deliveryboy/logout";

  static String orders = "deliveryboy/orders";
  static String order(int id) => "deliveryboy/orders/$id";
  static String updateStatus(String orderId) =>
      "deliveryboy/orders/$orderId/markasdelivered";
  static String updatePaymentStatus(String orderId) =>
      "deliveryboy/orders/$orderId/markaspaid";

  static String profile = "deliveryboy/profile";
  static String vendor = "deliveryboy/vendor";

  static String updatePassword = "deliveryboy/password/update";
  static String forgotPassword = "deliveryboy/forgot";
  static String resetPassword = "deliveryboy/reset";
}
