import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zcart_delivery/config/config.dart';
import 'package:zcart_delivery/helper/url_launcher_helper.dart';
import 'package:zcart_delivery/providers/vendor_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:zcart_delivery/translations/locale_keys.g.dart';

class VendorSupportPage extends ConsumerWidget {
  const VendorSupportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final _vendorProvider = ref.watch(vendorProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.vendor_support.tr()),
      ),
      body: _vendorProvider.when(
        data: (data) {
          return data == null
              ? Center(child: Text(LocaleKeys.no_item_found.tr()))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: data.image != null && data.image!.isNotEmpty
                                ? Image.network(
                                    data.image!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return CircleAvatar(
                                        backgroundColor: MyConfig.primaryColor,
                                        radius: 50,
                                        child: const Icon(
                                          Icons.store,
                                          color: Colors.white,
                                          size: 50,
                                        ),
                                      );
                                    },
                                  )
                                : CircleAvatar(
                                    backgroundColor: MyConfig.primaryColor,
                                    radius: 50,
                                    child: const Icon(
                                      Icons.store,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        data.name,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (data.contactNumber != null) {
                              launchURL("tel:${data.contactNumber}");
                            } else {
                              Fluttertoast.showToast(
                                  msg: LocaleKeys.not_available.tr());
                            }
                          },
                          label: Text(LocaleKeys.call_vendor.tr()),
                          icon: const Icon(Icons.call),
                        ),
                      ),
                    ],
                  ),
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
