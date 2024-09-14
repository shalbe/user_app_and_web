import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart_delivery/helper/constants.dart';
import 'package:zcart_delivery/providers/order_provider.dart';
import 'package:zcart_delivery/translations/locale_keys.g.dart';
import 'package:zcart_delivery/views/orders/components/order_list_item.dart';
import 'package:easy_localization/easy_localization.dart';

class OrdersPage extends ConsumerWidget {
  final bool isOnlyPending;
  final bool isOnlyDelivered;

  const OrdersPage({
    Key? key,
    this.isOnlyPending = false,
    this.isOnlyDelivered = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final _ordersProvider = ref.watch(ordersProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(isOnlyPending
            ? LocaleKeys.pending_orders.tr()
            : isOnlyDelivered
                ? LocaleKeys.completed_orders.tr()
                : LocaleKeys.all_orders.tr()),
        actions: [
          IconButton(
            tooltip: LocaleKeys.refresh.tr(),
            icon: const Icon(Icons.sync),
            onPressed: () {
              ref.refresh(ordersProvider);
            },
          ),
        ],
      ),
      body: _ordersProvider.when(
        data: (data) {
          if (data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var _data = isOnlyPending ? data : data.reversed.toList();

          if (isOnlyDelivered) {
            _data = _data
                .where((element) =>
                    element.orderStatus == 'delivered'.toUpperCase())
                .toList();
          }

          if (isOnlyPending) {
            _data = _data
                .where((element) =>
                    element.orderStatus != 'delivered'.toUpperCase())
                .toList();
          }

          return _data.isEmpty
              ? Center(child: Text(LocaleKeys.no_item_found.tr()))
              : ListView(
                  padding: const EdgeInsets.all(defaultPadding / 2),
                  children: _data.map((order) {
                    return OrderListItem(order: order);
                  }).toList(),
                );
        },
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
