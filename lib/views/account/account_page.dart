import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart_delivery/config/config.dart';
import 'package:zcart_delivery/helper/navigator_helper.dart';
import 'package:zcart_delivery/providers/auth_provider.dart';
import 'package:zcart_delivery/providers/order_provider.dart';
import 'package:zcart_delivery/translations/locale_keys.g.dart';
import 'package:zcart_delivery/views/account/change_password_page.dart';
import 'package:zcart_delivery/views/account/profile_page.dart';
import 'package:zcart_delivery/views/custom/update_language.dart';
import 'package:zcart_delivery/views/custom/version_info.dart';
import 'package:easy_localization/easy_localization.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        endDrawer: _drawer(context),
        appBar: AppBar(
          title: Text(LocaleKeys.account.tr()),
        ),
        body: Consumer(
          builder: (context, ref, child) {
            final _userProvider = ref.watch(userProvider);
            return _userProvider.when(
              data: (data) {
                return data != null
                    ? ProfilePage(user: data)
                    : Center(child: Text(LocaleKeys.something_went_wrong.tr()));
              },
              error: (error, stackTrace) => Center(
                child: Text(LocaleKeys.something_went_wrong.tr()),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ),
    );
  }

  Widget _drawer(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final _userProvider = ref.watch(userProvider);

        return Drawer(
          child: SafeArea(
            child: Column(
              children: [
                DrawerHeader(
                  child: Center(
                      child: _userProvider.when(
                    data: (data) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: data?.avatar != null &&
                                    data!.avatar!.isNotEmpty
                                ? Image.network(
                                    data.avatar!,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return CircleAvatar(
                                        backgroundColor: MyConfig.primaryColor,
                                        radius: 30,
                                        child: const Icon(
                                          Icons.person,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      );
                                    },
                                  )
                                : CircleAvatar(
                                    backgroundColor: MyConfig.primaryColor,
                                    radius: 30,
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 8),
                          Text(data != null
                              ? (data.niceName ?? LocaleKeys.not_available.tr())
                              : LocaleKeys.not_available.tr()),
                          Text(data != null
                              ? data.email
                              : LocaleKeys.not_available.tr()),
                        ],
                      );
                    },
                    error: (error, stackTrace) {
                      return const SizedBox();
                    },
                    loading: () {
                      return const SizedBox();
                    },
                  )),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        leading: const Icon(CupertinoIcons.lock),
                        title: Text(LocaleKeys.security.tr()),
                        onTap: () {
                          MyNav.goTo(context, const ChangePasswordPage());
                        },
                      ),
                      const Divider(height: 0, color: Colors.black12),
                      ListTile(
                        title: Text(
                          LocaleKeys.language.tr(),
                        ),
                        leading: const Icon(Icons.translate),
                        onTap: () {
                          updateLanguage(context);
                        },
                      ),
                      const Divider(height: 0, color: Colors.black12),
                      ListTile(
                        leading: const Icon(Icons.exit_to_app),
                        title: Text(LocaleKeys.logout.tr()),
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title:
                                    Text(LocaleKeys.log_out_confirmation.tr()),
                                content: Text(LocaleKeys.log_out_content.tr()),
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
                                      final _result =
                                          await AuthController.logout();
                                      if (_result) {
                                        ref.refresh(ordersProvider);
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      const Divider(height: 0, color: Colors.black12),
                    ],
                  ),
                ),
                const ShowVersionInfo(),
              ],
            ),
          ),
        );
      },
    );
  }
}
