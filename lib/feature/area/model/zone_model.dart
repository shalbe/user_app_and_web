import 'dart:math';

import 'package:demandium/components/core_export.dart';
import 'package:demandium/core/helper/degree_converter.dart';

class ZoneModel {
  String? id;
  String? name;
  List<Coordinates>? coordinates;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? restaurantWiseTopic;
  String? customerWiseTopic;
  String? deliverymanWiseTopic;
  double? minimumShippingCharge;
  double? perKmShippingCharge;

  ZoneModel({this.id, this.name, this.coordinates, this.status, this.createdAt, this.updatedAt, this.restaurantWiseTopic, this.customerWiseTopic, this.deliverymanWiseTopic, this.minimumShippingCharge, this.perKmShippingCharge});

  ZoneModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['coordinates'] != null) {
      coordinates = <Coordinates>[];
      json['coordinates'].forEach((v) {
        coordinates!.add(Coordinates.fromJson(v));
      });
    }
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    restaurantWiseTopic = json['restaurant_wise_topic'];
    customerWiseTopic = json['customer_wise_topic'];
    deliverymanWiseTopic = json['deliveryman_wise_topic'];
    minimumShippingCharge = json['minimum_shipping_charge'] != null ? json['minimum_shipping_charge'].toDouble() : 0;
    perKmShippingCharge = json['per_km_shipping_charge'] != null ? json['per_km_shipping_charge'].toDouble() : 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (coordinates != null) {
      data['coordinates'] = coordinates!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['restaurant_wise_topic'] = restaurantWiseTopic;
    data['customer_wise_topic'] = customerWiseTopic;
    data['deliveryman_wise_topic'] = deliverymanWiseTopic;
    data['minimum_shipping_charge'] = minimumShippingCharge;
    data['per_km_shipping_charge'] = perKmShippingCharge;
    return data;
  }

  double calculateDistance(LatLng point1, LatLng point2) {
    const earthRadius = 6371.0; // Earth's radius in kilometers
    final lat1Radians = degreeToRadian(point1.latitude);
    final lon1Radians = degreeToRadian(point1.longitude);
    final lat2Radians = degreeToRadian(point2.latitude);
    final lon2Radians = degreeToRadian(point2.longitude);

    final dlon = lon2Radians - lon1Radians;
    final dlat = lat2Radians - lat1Radians;

    final a = pow(sin(dlat / 2), 2) +
        cos(lat1Radians) * cos(lat2Radians) * pow(sin(dlon / 2), 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c; // Distance in kilometers
  }

}


