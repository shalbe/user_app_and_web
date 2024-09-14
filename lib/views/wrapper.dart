import 'package:flutter/material.dart';
import 'package:zcart_delivery/config/config.dart';
import 'package:zcart_delivery/translations/locale_keys.g.dart';
import 'package:zcart_delivery/views/account/account_page.dart';
import 'package:zcart_delivery/views/dashboard/dashboard_page.dart';
import 'package:zcart_delivery/views/orders/search_order_page.dart';
import 'package:zcart_delivery/views/support/vendor_support_page.dart';
import 'package:easy_localization/easy_localization.dart';

class WrapperPage extends StatelessWidget {
  const WrapperPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: DefaultTabController(
        length: 4,
        initialIndex: 0,
        child: Scaffold(
          bottomNavigationBar: SafeArea(
            child: TabBar(
              labelColor: Colors.black87,
              unselectedLabelColor: Colors.black38,
              indicatorColor: MyConfig.primaryColor,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: Theme.of(context).textTheme.caption!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              tabs: [
                Tab(
                  icon: const Icon(Icons.dashboard),
                  text: LocaleKeys.dashboard.tr(),
                ),
                Tab(
                  icon: const Icon(Icons.search),
                  text: LocaleKeys.search.tr(),
                ),
                Tab(
                  icon: const Icon(Icons.contact_support),
                  text: LocaleKeys.support.tr(),
                ),
                Tab(
                  icon: const Icon(Icons.account_circle_sharp),
                  text: LocaleKeys.account.tr(),
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              DashboardPage(),
              SearchOrderPage(),
              VendorSupportPage(),
              AccountPage(),
            ],
          ),
        ),
      ),
    );
  }
}
