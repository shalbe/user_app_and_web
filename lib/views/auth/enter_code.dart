import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zcart_delivery/helper/constants.dart';
import 'package:zcart_delivery/providers/auth_provider.dart';
import 'package:zcart_delivery/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:zcart_delivery/views/auth/reset_password.dart';

class EnterCodePage extends StatefulWidget {
  const EnterCodePage({Key? key}) : super(key: key);

  @override
  _EnterCodePageState createState() => _EnterCodePageState();
}

class _EnterCodePageState extends State<EnterCodePage> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.enter_code.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding * 2),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                autofocus: true,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontWeight: FontWeight.bold),
                controller: _codeController,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  hintText: LocaleKeys.enter_code.tr(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return LocaleKeys.enter_code.tr();
                  } else if (value.length < 6) {
                    return LocaleKeys.enter_valid_code.tr();
                  }
                  return null;
                },
              ),
              const SizedBox(height: defaultPadding),
              Text(LocaleKeys.enter_code_hint.tr()),
              const SizedBox(height: defaultPadding * 2),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await AuthController.validateCode(_codeController.text)
                        .then((value) {
                      if (value) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResetPasswordPage(
                              token: _codeController.text,
                            ),
                          ),
                        );
                      }
                    });
                  }
                },
                child: Text(LocaleKeys.submit.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
