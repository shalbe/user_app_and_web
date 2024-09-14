import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zcart_delivery/config/config.dart';
import 'package:zcart_delivery/helper/constants.dart';
import 'package:zcart_delivery/models/user_model.dart';
import 'package:zcart_delivery/providers/auth_provider.dart';
import 'package:zcart_delivery/translations/locale_keys.g.dart';
import 'package:zcart_delivery/views/custom/style_utils.dart';

class ProfilePage extends StatefulWidget {
  final UserModel user;
  const ProfilePage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _niceNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  File? _avatar;

  final List<GenderModel> _sex = [
    GenderModel(title: "Male", value: "app.male"),
    GenderModel(title: "Female", value: "app.female"),
    GenderModel(title: "Other", value: "app.other"),
  ];
  String? _selectedSex;
  String? _selectedSexValue;

  @override
  void initState() {
    _firstNameController.text = widget.user.firstName;
    _lastNameController.text = widget.user.lastName;
    _niceNameController.text = widget.user.niceName ?? '';
    _emailController.text = widget.user.email;
    _phoneController.text = widget.user.phoneNumber ?? '';

    _selectedSex = widget.user.sex;

    super.initState();
  }

  void _onTapUpdate(WidgetRef ref) async {
    if (_formKey.currentState!.validate()) {
      try {
        final _user = widget.user.copyWith(
            avatar: _avatar == null
                ? null
                : base64Encode(_avatar!.readAsBytesSync()),
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            niceName: _niceNameController.text.trim(),
            email: _emailController.text.trim(),
            phoneNumber: _phoneController.text.trim(),
            sex: _selectedSexValue ??
                _sex
                    .firstWhere(
                        (element) => element.title == (_selectedSex ?? ""))
                    .value);
        await AuthController.updateProfile(_user).then((value) {
          if (value) {
            ref.refresh(userProvider);
          }
        });
      } catch (e) {
        Fluttertoast.showToast(msg: LocaleKeys.something_went_wrong.tr());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: defaultPadding),
              GestureDetector(
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                  // Pick an image
                  final XFile? _image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (_image != null) {
                    setState(() {
                      _avatar = File(_image.path);
                    });
                  }
                },
                child: _avatar != null
                    ? ClipOval(
                        child: Image.file(
                          _avatar!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      )
                    : ClipOval(
                        child: widget.user.avatar != null &&
                                widget.user.avatar!.isNotEmpty
                            ? Image.network(
                                widget.user.avatar!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return CircleAvatar(
                                    backgroundColor: MyConfig.primaryColor,
                                    radius: 50,
                                    child: const Icon(
                                      Icons.person,
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
                                  Icons.person,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ),
                      ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: defaultPadding),
                  TextFormField(
                    controller: _firstNameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return LocaleKeys.field_required.tr();
                      }
                      return null;
                    },
                    decoration: textFieldDecoration(
                      label: LocaleKeys.first_name.tr(),
                      hint: LocaleKeys.first_name.tr(),
                    ),
                  ),
                  const SizedBox(height: defaultPadding),
                  TextFormField(
                    controller: _lastNameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return LocaleKeys.field_required.tr();
                      }
                      return null;
                    },
                    decoration: textFieldDecoration(
                      label: LocaleKeys.last_name.tr(),
                      hint: LocaleKeys.last_name.tr(),
                    ),
                  ),
                  const SizedBox(height: defaultPadding),
                  TextFormField(
                    controller: _niceNameController,
                    decoration: textFieldDecoration(
                      label: LocaleKeys.nick_name.tr(),
                      hint: LocaleKeys.nick_name.tr(),
                    ),
                  ),
                  const SizedBox(height: defaultPadding),
                  TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return LocaleKeys.field_required.tr();
                      } else if (!value.contains("@") || !value.contains(".")) {
                        return LocaleKeys.email_validation.tr();
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: textFieldDecoration(
                      label: LocaleKeys.email.tr(),
                      hint: LocaleKeys.email.tr(),
                    ),
                  ),
                  const SizedBox(height: defaultPadding),
                  TextFormField(
                    controller: _phoneController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value!.isEmpty) {
                        return LocaleKeys.field_required.tr();
                      }
                      return null;
                    },
                    decoration: textFieldDecoration(
                      label: LocaleKeys.phone.tr(),
                      hint: LocaleKeys.phone.tr(),
                    ).copyWith(),
                  ),
                  const SizedBox(height: defaultPadding),
                  DropdownButtonFormField<String>(
                    decoration: textFieldDecoration(
                      label: LocaleKeys.sex.tr(),
                      hint: LocaleKeys.sex.tr(),
                    ),
                    value: _selectedSex,
                    items: _sex.map((GenderModel e) {
                      return DropdownMenuItem<String>(
                        value: e.title,
                        child: Text(e.title),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSex = value;
                        if (value != null) {
                          _selectedSexValue = _sex
                              .firstWhere((element) => element.title == value)
                              .value;
                        }
                      });
                    },
                  ),
                  const SizedBox(height: defaultPadding),
                  Consumer(
                    builder: (context, ref, child) {
                      return ElevatedButton(
                        onPressed: () => _onTapUpdate(ref),
                        child: Text(LocaleKeys.update.tr()),
                      );
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GenderModel {
  String title;
  String value;
  GenderModel({
    required this.title,
    required this.value,
  });
}
