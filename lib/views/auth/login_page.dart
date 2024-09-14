import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zcart_delivery/config/config.dart';
import 'package:zcart_delivery/helper/app_images.dart';
import 'package:zcart_delivery/helper/constants.dart';
import 'package:zcart_delivery/network/network_helper.dart';
import 'package:zcart_delivery/providers/auth_provider.dart';
import 'package:zcart_delivery/providers/hive_provider.dart';
import 'package:zcart_delivery/providers/order_provider.dart';
import 'package:zcart_delivery/translations/locale_keys.g.dart';
import 'package:zcart_delivery/views/auth/enter_code.dart';
import 'package:zcart_delivery/views/custom/style_utils.dart';
import 'package:zcart_delivery/views/custom/version_info.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _resetPasswordKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _resetEmailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _showPassword = false;
  bool _savePassword = false;
  SavedAccount? _savedAccount;

  @override
  void initState() {
    _savedAccount = HiveProvider.getSavedAccount();

    if (_savedAccount != null) {
      _emailController.text = _savedAccount!.email;
      _passwordController.text = _savedAccount!.password;
      _savePassword = true;
    }

    super.initState();
  }

  void _onTapForgotPassword() async {
    await showDialog(
      context: context,
      builder: (context) {
        return Form(
          key: _resetPasswordKey,
          child: AlertDialog(
            title: Text(LocaleKeys.forgot_password.tr()),
            content: TextFormField(
              controller: _resetEmailController,
              keyboardType: TextInputType.emailAddress,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: textFieldDecoration(
                label: LocaleKeys.email.tr(),
                hint: LocaleKeys.email_hint.tr(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return LocaleKeys.email_validation.tr();
                } else if (!value.contains('@') || !value.contains('.')) {
                  return LocaleKeys.email_validation.tr();
                }
                return null;
              },
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                child: Text(LocaleKeys.cancel.tr()),
              ),
              TextButton(
                onPressed: () async {
                  if (_resetPasswordKey.currentState!.validate()) {
                    Fluttertoast.showToast(msg: LocaleKeys.please_wait.tr());
                    final _result = await AuthController.forgotPassword(
                        _resetEmailController.text.trim());

                    if (_result) {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return const EnterCodePage();
                      }));
                    }
                  }
                },
                child: Text(LocaleKeys.submit.tr()),
              ),
              const SizedBox(width: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0.0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.white,
        bottomSheet: const ShowVersionInfo(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(defaultPadding * 1.5),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Image.asset(
                  AppImages.logo,
                  height: 160,
                ),
                const SizedBox(height: defaultPadding),
                Text(
                  LocaleKeys.welcome.tr(),
                  style: Theme.of(context).textTheme.headline5,
                ),
                Text(
                  LocaleKeys.login_tagline.tr(),
                  style: Theme.of(context).textTheme.caption,
                ),
                const SizedBox(height: defaultPadding * 2),
                TextFormField(
                  controller: _emailController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.emailAddress,
                  decoration: textFieldDecoration(
                    label: LocaleKeys.email.tr(),
                    hint: LocaleKeys.email_hint.tr(),
                    prefixIcon: Icons.email,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return LocaleKeys.email_validation.tr();
                    } else if (!value.contains('@') || !value.contains('.')) {
                      return LocaleKeys.email_validation.tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: defaultPadding),
                TextFormField(
                  controller: _passwordController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: !_showPassword,
                  decoration: textFieldDecoration(
                    label: LocaleKeys.password.tr(),
                    hint: LocaleKeys.password_hint.tr(),
                    prefixIcon: Icons.lock,
                    suffixWidget: IconButton(
                        onPressed: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                        icon: const Icon(Icons.remove_red_eye)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return LocaleKeys.password_validation.tr();
                    } else if (value.length < 6) {
                      return LocaleKeys.password_validation.tr();
                    }
                    return null;
                  },
                ),
                // const SizedBox(height: defaultPadding),
                CheckboxListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: MyConfig.primaryColor,
                  title: Text(LocaleKeys.save_password.tr()),
                  value: _savePassword,
                  onChanged: (value) {
                    setState(() {
                      _savePassword = value!;
                    });
                  },
                ),
                // const SizedBox(height: defaultPadding),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final _user = await AuthController.login(
                          _emailController.text.trim(),
                          _passwordController.text.trim());

                      if (_user != null) {
                        await setAccessToken(_user.apiToken)
                            .then((value) async {
                          if (_savePassword == true) {
                            SavedAccount _account = SavedAccount(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                            );
                            HiveProvider.setSavedAccount(_account);
                          } else {
                            HiveProvider.setSavedAccount(
                                SavedAccount(email: "", password: ""));
                          }

                          ref.refresh(ordersProvider);
                          ref.refresh(userProvider);
                        });
                      }
                    }
                  },
                  child: Text(LocaleKeys.login.tr()),
                ),
                const SizedBox(height: defaultPadding / 2),
                GestureDetector(
                  onTap: _onTapForgotPassword,
                  child: Text(
                    LocaleKeys.forgot_password.tr(),
                    textAlign: TextAlign.end,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
