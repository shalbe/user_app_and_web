import 'package:flutter/material.dart';
import 'package:zcart_delivery/helper/constants.dart';
import 'package:zcart_delivery/models/order_light_model.dart';
import 'package:zcart_delivery/translations/locale_keys.g.dart';
import 'package:zcart_delivery/views/custom/inline_title_info_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:zcart_delivery/views/orders/order_detail_page.dart';

class OrderListItem extends StatelessWidget {
  final OrderLightModel order;

  const OrderListItem({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: defaultPadding / 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(defaultRadius),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 5,
            color: Colors.black12,
          ),
        ],
      ),
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InlineTitleInfoItem(
                  info: order.orderNumber, title: LocaleKeys.order_number.tr()),
              Text(order.orderDate),
            ],
          ),
          const SizedBox(height: defaultPadding / 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InlineTitleInfoItem(
                  info: order.grandTotal, title: LocaleKeys.order_amount.tr()),
              Text(
                order.paymentStatus ?? '',
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: order.paymentStatus?.toLowerCase() == 'paid'
                          ? Colors.green
                          : Colors.red,
                    ),
              ),
            ],
          ),
          const SizedBox(height: defaultPadding / 3),
          InlineTitleInfoItem(
              title: LocaleKeys.items.tr(),
              info: order.items.length.toString()),
          const SizedBox(height: defaultPadding / 3),
          // InlineTitleInfoItem(
          //     title: LocaleKeys.ship_to.tr(),
          //     info: order.shippingAddress.toString(),
          //     isSmallText: true),
          // const SizedBox(height: defaultPadding / 3),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 4,
            children: [
              OutlinedButton(
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderDetailPage(
                              orderId: order.id,
                              orderNumber: order.orderNumber)));
                },
                child: Text(LocaleKeys.manage_orders.tr()),
              ),
              Chip(
                backgroundColor: order.orderStatus == "delivered".toUpperCase()
                    ? Colors.green
                    : null,
                label: Text(
                  order.orderStatus,
                  style: TextStyle(
                    color: order.orderStatus == "delivered".toUpperCase()
                        ? Colors.white
                        : null,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
