import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zcart_delivery/config/config.dart';
import 'package:zcart_delivery/helper/constants.dart';
import 'package:zcart_delivery/providers/order_provider.dart';
import 'package:zcart_delivery/translations/codegen_loader.g.dart';
import 'package:zcart_delivery/translations/locale_keys.g.dart';
import 'package:zcart_delivery/translations/supported_locales.dart';
import 'package:zcart_delivery/views/auth/login_page.dart';
import 'package:zcart_delivery/views/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox(hiveBox);

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(
    EasyLocalization(
      path: "assets/translations",
      supportedLocales: supportedLocales,
      fallbackLocale: const Locale("en"),
      assetLoader: const CodegenLoader(),
      child: const ProviderScope(child: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    //
    //THEME
    final _themeData = ThemeData(
      colorScheme: const ColorScheme.light().copyWith(
        primary: MyConfig.primaryColor,
        secondary: MyConfig.accentColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        surface: Colors.white,
        onSurface: Colors.black87,
        error: Colors.red,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        // toolbarHeight: defaultPadding * 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(defaultRadius),
            bottomRight: Radius.circular(defaultRadius),
          ),
        ),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: GoogleFonts.latoTextTheme(
        Theme.of(context).textTheme,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        elevation: 0,
        textStyle: GoogleFonts.poppins(
          textStyle: Theme.of(context).textTheme.subtitle2,
          fontWeight: FontWeight.bold,
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultRadius),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultRadius),
        ),
      )),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          textStyle: GoogleFonts.poppins(
            textStyle: Theme.of(context).textTheme.subtitle2,
            fontWeight: FontWeight.bold,
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultRadius),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: GoogleFonts.poppins(
            textStyle: Theme.of(context).textTheme.subtitle2,
            fontWeight: FontWeight.bold,
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultRadius),
          ),
        ),
      ),
    );

    //

    return MaterialApp(
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      locale: context.locale,
      title: MyConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: _themeData,
      home: const LandingPage(),
    );
  }
}

class LandingPage extends ConsumerWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final _ordersProvider = ref.watch(ordersProvider);
    return _ordersProvider.when(
      data: (data) {
        if (data == null) {
          return const LoginPage();
        } else {
          return const WrapperPage();
        }
      },
      error: (error, stackTrace) => const ErrorPage(),
      loading: () => const LoadingPage(),
    );
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(MyConfig.appName),
        centerTitle: true,
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Center(
        child: Text(LocaleKeys.something_went_wrong.tr()),
      ),
    );
  }
}
