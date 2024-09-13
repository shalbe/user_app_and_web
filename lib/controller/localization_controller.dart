import 'dart:convert';
import 'package:demandium/feature/area/controller/service_area_controller.dart';
import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';

class LocalizationController extends GetxController implements GetxService {
  late SharedPreferences sharedPreferences;
  late ApiClient apiClient;

  LocalizationController({required this.sharedPreferences, required this.apiClient}) {
    loadCurrentLanguage();
  }

  Locale _locale = Locale(AppConstants.languages[0].languageCode!, AppConstants.languages[0].countryCode);
  bool _isLtr = true;
  List<LanguageModel> _languages = [];

  Locale get locale => _locale;
  bool get isLtr => _isLtr;
  List<LanguageModel> get languages => _languages;

  void setLanguage(Locale locale, {bool isInitial = false}) {
    Get.updateLocale(locale);
    _locale = locale;
    if(_locale.languageCode == 'ar') {
      _isLtr = false;
    }else {
      _isLtr = true;
    }
    AddressModel? addressModel;
    try {
      addressModel = AddressModel.fromJson(jsonDecode(sharedPreferences.getString(AppConstants.userAddress)!));
    }catch(e) {
      if (kDebugMode) {
        print(e);
      }
    }
    ///pick zone id to update header
    apiClient.updateHeader(
      sharedPreferences.getString(AppConstants.token), addressModel?.zoneId,
      locale.languageCode, Get.find<SplashController>().getGuestId(),
    );
    saveLanguage(_locale);
    if(Get.find<LocationController>().getUserAddress() != null) {
      HomeScreen.loadData(true);
      Get.find<ServiceAreaController>().getZoneList();
    }
    Get.find<SplashController>().updateLanguage(isInitial);
    update();
  }

  void loadCurrentLanguage() async {
    _locale = Locale(sharedPreferences.getString(AppConstants.languageCode) ?? AppConstants.languages[0].languageCode!,
        sharedPreferences.getString(AppConstants.countryCode) ?? AppConstants.languages[0].countryCode);
    _isLtr = _locale.languageCode != 'ar';
    for(int index = 0; index<AppConstants.languages.length; index++) {
      if(AppConstants.languages[index].languageCode == _locale.languageCode) {
        _selectedIndex = index;
        break;
      }
    }
    _languages = [];
    _languages.addAll(AppConstants.languages);
    update();
  }

  void saveLanguage(Locale locale) async {
    sharedPreferences.setString(AppConstants.languageCode, locale.languageCode);
    sharedPreferences.setString(AppConstants.countryCode, locale.countryCode!);
    update();
  }

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  void setSelectIndex(int index, {bool shouldUpdate = true}) {
    _selectedIndex = index;
    if(shouldUpdate){
      update();
    }
  }

}