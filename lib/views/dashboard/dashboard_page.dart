import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart_delivery/config/config.dart';
import 'package:zcart_delivery/helper/constants.dart';
import 'package:zcart_delivery/providers/order_provider.dart';
import 'package:zcart_delivery/translations/locale_keys.g.dart';
import 'package:zcart_delivery/views/custom/information_card_icon.dart';
import 'package:zcart_delivery/views/orders/orders_page.dart';
import 'package:easy_localization/easy_localization.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: _appbar(ref),
      body: _body(context, ref),
    );
  }

  Widget _body(BuildContext context, WidgetRef ref) {
    final _ordersProvider = ref.watch(ordersProvider);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ordersProvider.when(
              data: (data) {
                if (data == null) {
                  return const SizedBox();
                } else {
                  final _data = data
                      .where((element) =>
                          element.orderStatus != 'delivered'.toUpperCase())
                      .toList();

                  return InformationCardWithIcon(
                    icon: Icons.shopping_bag,
                    iconColor: Colors.orange,
                    number: _data.length.toString(),
                    title: LocaleKeys.pending_delivery.tr(),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const OrdersPage(isOnlyPending: true),
                        ),
                      );
                    },
                  );
                }
              },
              error: (error, stackTrace) => const SizedBox(),
              loading: () => const InfoCardShimmer(),
            ),
            const SizedBox(height: defaultPadding),
            _ordersProvider.when(
              data: (data) {
                return data != null
                    ? InformationCardWithIcon(
                        icon: Icons.shopping_basket,
                        iconColor: MyConfig.primaryColor,
                        number: data.length.toString(),
                        title: LocaleKeys.all_orders.tr(),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OrdersPage(),
                            ),
                          );
                        },
                      )
                    : const SizedBox();
              },
              error: (error, stackTrace) => const SizedBox(),
              loading: () => const InfoCardShimmer(),
            ),
            const SizedBox(height: defaultPadding),
            _ordersProvider.when(
              data: (data) {
                if (data == null) {
                  return const SizedBox();
                }
                final _data = data
                    .where((element) =>
                        element.orderStatus == 'delivered'.toUpperCase())
                    .toList();
                return InformationCardWithIcon(
                  icon: CupertinoIcons.rectangle_grid_2x2_fill,
                  iconColor: Colors.green,
                  number: _data.length.toString(),
                  title: LocaleKeys.completed_delivery.tr(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const OrdersPage(isOnlyDelivered: true),
                      ),
                    );
                  },
                );
              },
              error: (error, stackTrace) => const SizedBox(),
              loading: () => const InfoCardShimmer(),
            ),
            const SizedBox(height: defaultPadding),
          ],
        ),
      ),
    );
  }

  AppBar _appbar(WidgetRef ref) {
    return AppBar(
      title: Text(LocaleKeys.dashboard.tr()),
      actions: [
        IconButton(
          tooltip: LocaleKeys.refresh.tr(),
          icon: const Icon(Icons.sync),
          onPressed: () {
            _refreshData(ref);
          },
        ),
      ],
    );
  }
}

void _refreshData(WidgetRef ref) {
  ref.refresh(ordersProvider);
}
