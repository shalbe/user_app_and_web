import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart_delivery/helper/constants.dart';
import 'package:zcart_delivery/providers/auth_provider.dart';
import 'package:zcart_delivery/translations/locale_keys.g.dart';
import 'package:zcart_delivery/views/custom/style_utils.dart';

class ResetPasswordPage extends StatefulWidget {
  final String token;
  const ResetPasswordPage({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.reset_password.tr()),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _passwordController,
              obscureText: !_showPassword,
              validator: (value) {
                if (value!.isEmpty) {
                  return LocaleKeys.password_validation.tr();
                }
                return null;
              },
              decoration: textFieldDecoration(
                label: LocaleKeys.new_password.tr(),
                hint: LocaleKeys.new_password.tr(),
                suffixWidget: IconButton(
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                    icon: const Icon(Icons.remove_red_eye)),
              ),
            ),
            const SizedBox(height: defaultPadding),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: !_showConfirmPassword,
              validator: (value) {
                if (value!.isEmpty) {
                  return LocaleKeys.password_validation.tr();
                } else if (value != _passwordController.text) {
                  return LocaleKeys.password_match_validation.tr();
                }
                return null;
              },
              decoration: textFieldDecoration(
                label: LocaleKeys.confirm_password.tr(),
                hint: LocaleKeys.confirm_password.tr(),
                suffixWidget: IconButton(
                    onPressed: () {
                      setState(() {
                        _showConfirmPassword = !_showConfirmPassword;
                      });
                    },
                    icon: const Icon(Icons.remove_red_eye)),
              ),
            ),
            const SizedBox(height: defaultPadding),
            Consumer(
              builder: (context, ref, child) {
                return ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await AuthController.resetPassword(
                              _confirmPasswordController.text.trim(),
                              widget.token)
                          .then((value) {
                        if (value) {
                          Navigator.of(context).pop();
                        }
                      });
                    }
                  },
                  child: Text(LocaleKeys.update.tr()),
                );
              },
            ),
            const SizedBox(height: defaultPadding),
          ],
        ),
      ),
    );
  }
}
