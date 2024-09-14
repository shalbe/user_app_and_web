import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zcart_delivery/config/config.dart';
import 'package:zcart_delivery/helper/constants.dart';
import 'package:zcart_delivery/helper/get_amount_from_string.dart';
import 'package:zcart_delivery/helper/url_launcher_helper.dart';
import 'package:zcart_delivery/models/order_model.dart';
import 'package:zcart_delivery/providers/order_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:zcart_delivery/translations/locale_keys.g.dart';

class OrderDetailPage extends ConsumerWidget {
  final int orderId;
  final String orderNumber;
  const OrderDetailPage({
    Key? key,
    required this.orderId,
    required this.orderNumber,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _orderProvider = ref.watch(orderProvider(orderId));

    return Scaffold(
      appBar: AppBar(
        title: Text("${LocaleKeys.order.tr()} $orderNumber"),
        actions: [
          IconButton(
            tooltip: LocaleKeys.refresh.tr(),
            icon: const Icon(Icons.sync),
            onPressed: () {
              ref.refresh(orderProvider(orderId));
            },
          ),
        ],
      ),
      body: _orderProvider.when(
        data: (data) {
          if (data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return OrderDetailBody(order: data);
        },
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class OrderDetailBody extends StatelessWidget {
  final OrderModel order;
  const OrderDetailBody({
    Key? key,
    required this.order,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final bool _isDelivered = order.orderStatus == "delivered".toUpperCase();
    final bool _isPaid = order.paymentStatus == "paid".toUpperCase();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(order.orderDate,
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.black87)),
              Chip(
                backgroundColor: order.orderStatus == "delivered".toUpperCase()
                    ? Colors.green
                    : null,
                label: Text(
                  order.orderStatus,
                  style: TextStyle(
                    color: order.orderStatus == "delivered".toUpperCase()
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: defaultPadding),
          Text(
            LocaleKeys.customer_name.tr(),
            style: Theme.of(context).textTheme.caption!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
          ),
          const SizedBox(height: defaultPadding / 3),
          SelectableText(
            order.customer?.name ?? LocaleKeys.not_available.tr(),
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
          ),
          const SizedBox(height: defaultPadding),
          Text(
            LocaleKeys.customer_phone.tr(),
            style: Theme.of(context).textTheme.caption!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
          ),
          const SizedBox(height: defaultPadding / 3),
          SelectableText(
            (order.customerPhoneNumber == null ||
                    order.customerPhoneNumber!.isEmpty)
                ? LocaleKeys.not_available.tr()
                : order.customerPhoneNumber!,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
          ),
          const SizedBox(height: defaultPadding),
          Text(
            LocaleKeys.customer_email.tr(),
            style: Theme.of(context).textTheme.caption!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
          ),
          const SizedBox(height: defaultPadding / 3),
          SelectableText(
            order.email ??
                order.customer?.email ??
                LocaleKeys.not_available.tr(),
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
          ),
          const SizedBox(height: defaultPadding),
          Text(
            LocaleKeys.shipping_address.tr(),
            style: Theme.of(context).textTheme.caption!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
          ),
          const SizedBox(height: defaultPadding / 3),
          SelectableText(
            order.shippingAddress,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
          ),
          const SizedBox(height: defaultPadding),
          Text(
            LocaleKeys.payment_method.tr(),
            style: Theme.of(context).textTheme.caption!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
          ),
          const SizedBox(height: defaultPadding / 3),
          Text(
            order.paymentMethod.name,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
          ),
          const SizedBox(height: defaultPadding),
          Text(
            LocaleKeys.payment_status.tr(),
            style: Theme.of(context).textTheme.caption!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
          ),
          const SizedBox(height: defaultPadding / 3),
          Text(
            order.paymentStatus ?? LocaleKeys.unknown.tr(),
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
          ),
          const SizedBox(height: 24),
          Container(
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
            child: Column(
              children: [
                ListTile(
                  dense: true,
                  title: Text(
                    order.shop.name,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                  ),
                  leading: order.shop.image != null
                      ? SizedBox(
                          width: 40,
                          height: 40,
                          child: Image.network(order.shop.image!,
                              fit: BoxFit.contain),
                        )
                      : null,
                  subtitle: Text(
                    order.shop.verifiedText ?? LocaleKeys.not_verified.tr(),
                    style: Theme.of(context).textTheme.caption!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        color: MyConfig.primaryColor),
                  ),
                ),
                const Divider(
                    height: 8,
                    //color: MyConfig.primaryColor.withOpacity(0.3),
                    //color: Colors.black8712,
                    thickness: 2,
                    indent: 16,
                    endIndent: 16),
                for (var item in order.items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: item.image != null
                          ? SizedBox(
                              width: 40,
                              height: 40,
                              child:
                                  Image.network(item.image!, fit: BoxFit.cover),
                            )
                          : null,
                      title: Text(
                        item.description! + " x " + item.quantity.toString(),
                        style: Theme.of(context).textTheme.caption!.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      subtitle: Text(
                        item.total,
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: MyConfig.primaryColor,
                            ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ItemPriceWidget(
              title: LocaleKeys.item_total.tr(), price: order.total),
          order.shipping != null && getAmountFromString(order.shipping!) > 0
              ? ItemPriceWidget(
                  title: LocaleKeys.shipping_total.tr(), price: order.shipping!)
              : const SizedBox(),
          order.packaging != null && getAmountFromString(order.packaging!) > 0
              ? ItemPriceWidget(
                  title: LocaleKeys.packaging_total.tr(),
                  price: order.packaging)
              : const SizedBox(),
          order.handling != null && getAmountFromString(order.handling!) > 0
              ? ItemPriceWidget(
                  title: LocaleKeys.handling_total.tr(), price: order.handling)
              : const SizedBox(),
          order.taxes != null && getAmountFromString(order.taxes!) > 0
              ? ItemPriceWidget(
                  title: LocaleKeys.tax_total.tr(), price: order.taxes)
              : const SizedBox(),
          order.discount != null && getAmountFromString(order.discount!) > 0
              ? ItemPriceWidget(
                  title: LocaleKeys.discount_total.tr(),
                  price: "- " + order.discount)
              : const SizedBox(),
          const Divider(height: 16, thickness: 2),
          ItemPriceWidget(
            title: LocaleKeys.grand_total.tr(),
            price: order.grandTotal,
            isTotal: true,
          ),
          const SizedBox(height: 32),
          Consumer(
            builder: (context, ref, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  (order.customerPhoneNumber == null ||
                          order.customerPhoneNumber!.isEmpty)
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              launchURL("tel:${order.customerPhoneNumber!}");
                            },
                            label: Text(LocaleKeys.call_customer.tr()),
                            icon: const Icon(Icons.call),
                          ),
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _isPaid
                          ? const SizedBox()
                          : Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  _onPressedPaid(order.id, ref, context);
                                },
                                child: Text(
                                  LocaleKeys.mark_as_paid.tr(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                      if (!_isPaid && !_isDelivered) const SizedBox(width: 8),
                      _isDelivered
                          ? const SizedBox()
                          : Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  _onPressedDelivered(order.id, ref, context);
                                },
                                child: Text(
                                  LocaleKeys.mark_as_delivered.tr(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _onPressedPaid(int orderId, WidgetRef ref, BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(LocaleKeys.are_you_sure.tr()),
          content: Text(LocaleKeys.mark_as_paid_confirm.tr()),
          actions: [
            TextButton(
              child: Text(LocaleKeys.cancel.tr()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(LocaleKeys.yes.tr()),
              onPressed: () async {
                Navigator.of(context).pop();
                Fluttertoast.showToast(msg: LocaleKeys.please_wait.tr());
                final _result =
                    await OrderController.updatePaymentStatus(order.id);
                if (_result == true) {
                  ref.refresh(orderProvider(orderId));
                  ref.refresh(ordersProvider);
                } else {
                  Fluttertoast.showToast(
                      msg: LocaleKeys.something_went_wrong.tr());
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _onPressedDelivered(
      int orderId, WidgetRef ref, BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(LocaleKeys.are_you_sure.tr()),
          content: Text(LocaleKeys.mark_as_delivered_confirm.tr()),
          actions: [
            TextButton(
              child: Text(LocaleKeys.cancel.tr()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(LocaleKeys.yes.tr()),
              onPressed: () async {
                Navigator.of(context).pop();
                Fluttertoast.showToast(msg: LocaleKeys.please_wait.tr());

                final _result = await OrderController.updateStatus(order.id, 6);
                if (_result == true) {
                  ref.refresh(orderProvider(orderId));
                  ref.refresh(ordersProvider);
                } else {
                  Fluttertoast.showToast(
                      msg: LocaleKeys.something_went_wrong.tr());
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class ItemPriceWidget extends StatelessWidget {
  final String title;
  final String price;
  final bool isTotal;
  const ItemPriceWidget({
    Key? key,
    required this.title,
    required this.price,
    this.isTotal = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: defaultPadding / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: isTotal
                ? Theme.of(context).textTheme.subtitle2!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 20)
                : Theme.of(context).textTheme.caption!.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.black54),
          ),
          Text(
            price,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: MyConfig.primaryColor,
                  fontSize: isTotal ? 20 : null,
                ),
          ),
        ],
      ),
    );
  }
}
