import 'dart:convert';

OrderLightModel orderLightModelFromJson(String str) =>
    OrderLightModel.fromJson(json.decode(str));

String orderLightModelToJson(OrderLightModel data) =>
    json.encode(data.toJson());

class OrderLightModel {
  OrderLightModel({
    required this.id,
    required this.orderNumber,
    this.customerId,
    this.disputeId,
    required this.orderStatus,
    this.paymentStatus,
    this.messageToCustomer,
    required this.grandTotal,
    required this.grandTotalRaw,
    required this.orderDate,
    this.shippingDate,
    this.deliveryDate,
    this.goodsReceived,
    this.canEvaluate,
    this.trackingId,
    this.trackingUrl,
    required this.shop,
    required this.items,
  });

  int id;
  String orderNumber;
  int? customerId;
  dynamic disputeId;
  String orderStatus;
  String? paymentStatus;
  dynamic messageToCustomer;
  String grandTotal;
  String grandTotalRaw;
  String orderDate;
  dynamic shippingDate;
  dynamic deliveryDate;
  dynamic goodsReceived;
  bool? canEvaluate;
  String? trackingId;
  dynamic trackingUrl;
  Shop shop;
  List<Item> items;

  factory OrderLightModel.fromJson(Map<String, dynamic> json) =>
      OrderLightModel(
        id: json["id"],
        orderNumber: json["order_number"],
        customerId: json["customer_id"],
        disputeId: json["dispute_id"],
        orderStatus: json["order_status"],
        paymentStatus: json["payment_status"],
        messageToCustomer: json["message_to_customer"],
        grandTotal: json["grand_total"],
        grandTotalRaw: json["grand_total_raw"],
        orderDate: json["order_date"],
        shippingDate: json["shipping_date"],
        deliveryDate: json["delivery_date"],
        goodsReceived: json["goods_received"],
        canEvaluate: json["can_evaluate"],
        trackingId: json["tracking_id"],
        trackingUrl: json["tracking_url"],
        shop: Shop.fromJson(json["shop"]),
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_number": orderNumber,
        "customer_id": customerId,
        "dispute_id": disputeId,
        "order_status": orderStatus,
        "payment_status": paymentStatus,
        "message_to_customer": messageToCustomer,
        "grand_total": grandTotal,
        "grand_total_raw": grandTotalRaw,
        "order_date": orderDate,
        "shipping_date": shippingDate,
        "delivery_date": deliveryDate,
        "goods_received": goodsReceived,
        "can_evaluate": canEvaluate,
        "tracking_id": trackingId,
        "tracking_url": trackingUrl,
        "shop": shop.toJson(),
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Item {
  Item({
    this.id,
    required this.slug,
    this.description,
    required this.quantity,
    required this.unitPrice,
    required this.total,
    this.image,
  });

  int? id;
  String slug;
  String? description;
  int quantity;
  String unitPrice;
  String total;
  String? image;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        slug: json["slug"],
        description: json["description"],
        quantity: json["quantity"],
        unitPrice: json["unit_price"],
        total: json["total"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "slug": slug,
        "description": description,
        "quantity": quantity,
        "unit_price": unitPrice,
        "total": total,
        "image": image,
      };
}

class Shop {
  Shop({
    this.id,
    required this.name,
    required this.slug,
    this.verified,
    this.verifiedText,
    this.rating,
    this.image,
  });

  int? id;
  String name;
  String slug;
  bool? verified;
  String? verifiedText;
  String? rating;
  String? image;

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        verified: json["verified"],
        verifiedText: json["verified_text"],
        rating: json["rating"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "verified": verified,
        "verified_text": verifiedText,
        "rating": rating,
        "image": image,
      };
}
