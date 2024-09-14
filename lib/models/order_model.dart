class OrderModel {
  OrderModel({
    required this.id,
    required this.orderNumber,
    this.customerId,
    this.customerPhoneNumber,
    this.ipAddress,
    this.email,
    this.disputeId,
    required this.orderStatus,
    this.paymentStatus,
    required this.paymentMethod,
    this.messageToCustomer,
    this.buyerNote,
    this.shipTo,
    this.shippingZoneId,
    this.shippingRateId,
    required this.shippingAddress,
    this.billingAddress,
    this.shippingWeight,
    this.packagingId,
    this.couponId,
    required this.total,
    this.shipping,
    this.packaging,
    this.handling,
    this.taxes,
    this.discount,
    required this.grandTotal,
    this.taxrate,
    required this.orderDate,
    this.shippingDate,
    this.deliveryDate,
    this.goodsReceived,
    this.canEvaluate,
    this.trackingId,
    this.trackingUrl,
    this.customer,
    required this.shop,
    required this.items,
    this.conversation,
  });

  int id;
  String orderNumber;
  int? customerId;
  String? customerPhoneNumber;
  dynamic ipAddress;
  dynamic email;
  dynamic disputeId;
  String orderStatus;
  String? paymentStatus;
  PaymentMethod paymentMethod;
  dynamic messageToCustomer;
  String? buyerNote;
  dynamic shipTo;
  dynamic shippingZoneId;
  int? shippingRateId;
  String shippingAddress;
  String? billingAddress;
  String? shippingWeight;
  int? packagingId;
  dynamic couponId;
  String total;
  String? shipping;
  dynamic packaging;
  dynamic handling;
  dynamic taxes;
  dynamic discount;
  String grandTotal;
  dynamic taxrate;
  String orderDate;
  dynamic shippingDate;
  dynamic deliveryDate;
  dynamic goodsReceived;
  bool? canEvaluate;
  String? trackingId;
  dynamic trackingUrl;
  Customer? customer;
  Shop shop;
  List<Item> items;
  dynamic conversation;

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json["id"],
        orderNumber: json["order_number"],
        customerId: json["customer_id"],
        customerPhoneNumber: json["customer_phone_number"],
        ipAddress: json["ip_address"],
        email: json["email"],
        disputeId: json["dispute_id"],
        orderStatus: json["order_status"],
        paymentStatus: json["payment_status"],
        paymentMethod: PaymentMethod.fromJson(json["payment_method"]),
        messageToCustomer: json["message_to_customer"],
        buyerNote: json["buyer_note"],
        shipTo: json["ship_to"],
        shippingZoneId: json["shipping_zone_id"],
        shippingRateId: json["shipping_rate_id"],
        shippingAddress: json["shipping_address"],
        billingAddress: json["billing_address"],
        shippingWeight: json["shipping_weight"],
        packagingId: json["packaging_id"],
        couponId: json["coupon_id"],
        total: json["total"],
        shipping: json["shipping"],
        packaging: json["packaging"],
        handling: json["handling"],
        taxes: json["taxes"],
        discount: json["discount"],
        grandTotal: json["grand_total"],
        taxrate: json["taxrate"],
        orderDate: json["order_date"],
        shippingDate: json["shipping_date"],
        deliveryDate: json["delivery_date"],
        goodsReceived: json["goods_received"],
        canEvaluate: json["can_evaluate"],
        trackingId: json["tracking_id"],
        trackingUrl: json["tracking_url"],
        customer: json["customer"] == null
            ? null
            : Customer.fromJson(json["customer"]),
        shop: Shop.fromJson(json["shop"]),
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        conversation: json["conversation"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_number": orderNumber,
        "customer_id": customerId,
        "customer_phone_number": customerPhoneNumber,
        "ip_address": ipAddress,
        "email": email,
        "dispute_id": disputeId,
        "order_status": orderStatus,
        "payment_status": paymentStatus,
        "payment_method": paymentMethod.toJson(),
        "message_to_customer": messageToCustomer,
        "buyer_note": buyerNote,
        "ship_to": shipTo,
        "shipping_zone_id": shippingZoneId,
        "shipping_rate_id": shippingRateId,
        "shipping_address": shippingAddress,
        "billing_address": billingAddress,
        "shipping_weight": shippingWeight,
        "packaging_id": packagingId,
        "coupon_id": couponId,
        "total": total,
        "shipping": shipping,
        "packaging": packaging,
        "handling": handling,
        "taxes": taxes,
        "discount": discount,
        "grand_total": grandTotal,
        "taxrate": taxrate,
        "order_date": orderDate,
        "shipping_date": shippingDate,
        "delivery_date": deliveryDate,
        "goods_received": goodsReceived,
        "can_evaluate": canEvaluate,
        "tracking_id": trackingId,
        "tracking_url": trackingUrl,
        "customer": customer?.toJson(),
        "shop": shop.toJson(),
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "conversation": conversation,
      };
}

class Customer {
  Customer({
    this.id,
    this.name,
    this.email,
    this.active,
    this.avatar,
  });

  int? id;
  String? name;
  String? email;
  bool? active;
  String? avatar;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        active: json["active"],
        avatar: json["avatar"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "active": active,
        "avatar": avatar,
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

class PaymentMethod {
  PaymentMethod({
    required this.id,
    required this.order,
    this.type,
    required this.code,
    required this.name,
  });

  int id;
  int order;
  String? type;
  String code;
  String name;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        id: json["id"],
        order: json["order"],
        type: json["type"],
        code: json["code"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order": order,
        "type": type,
        "code": code,
        "name": name,
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
