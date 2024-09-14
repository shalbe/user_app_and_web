import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:zcart_delivery/translations/iso_codes.dart';
import 'package:zcart_delivery/translations/supported_locales.dart';

void updateLanguage(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return ListView(
        children: supportedLocales.map((locale) {
          return Padding(
            padding: EdgeInsets.only(
                right: 16,
                left: 16,
                top: supportedLocales.indexOf(locale) == 0 ? 16 : 0),
            child: Card(
              child: ListTile(
                onTap: () async {
                  Navigator.pop(context);
                  await context.setLocale(locale);
                },
                leading: Localizations.localeOf(context).languageCode ==
                        locale.languageCode
                    ? const Icon(Icons.radio_button_checked)
                    : const Icon(Icons.radio_button_off),
                title: Text(isoLangs[locale.languageCode]!["nativeName"]!
                    .split(",")
                    .first),
                trailing: Text(
                    isoLangs[locale.languageCode]!["name"]!.split(",").first,
                    style: Theme.of(context).textTheme.caption),
              ),
            ),
          );
        }).toList(),
      );
    },
  );
}
