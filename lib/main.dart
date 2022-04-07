import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:an_muk_so/search/search.dart';
import 'package:an_muk_so/initial/1_policy_agree.dart';
import 'package:an_muk_so/initial/2_get_privacy.dart';
import 'package:an_muk_so/services/auth.dart';
import 'package:an_muk_so/theme/colors.dart';

import 'bottom_bar_navigation.dart';
import 'home/home.dart';
import 'login/login.dart';
import 'ranking/ranking.dart';
import 'package:an_muk_so/models/user.dart';
import 'package:an_muk_so/wrapper.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // if (defaultTargetPlatform == TargetPlatform.android) {
  //   InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  // }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<TheUser>(
      create: (_) => AuthService().user,
      child: MaterialApp(
          title: 'AN MUK SO ver 1.0',
          home: Wrapper(),
          debugShowCheckedModeBanner: false,
          routes: {
            // TODO: Add route
            '/start': (context) => Wrapper(),
            '/login': (context) => LoginPage(),
            '/policy_agree': (context) => PolicyAgreePage(),
            '/get_privacy': (context) => GetPrivacyPage(),
            '/home': (context) => HomePage(),
            '/ranking': (context) => RankingPage(),
            '/bottom_bar': (context) => BottomBar(),
            '/search': (context) => SearchScreen(),
          },
          theme: _AMSTheme),
    );
  }
}

final ThemeData _AMSTheme = _buildAMSTheme();

ThemeData _buildAMSTheme() {
  final ThemeData base = ThemeData();
  return base.copyWith(
    primaryColor: primary300_main,
    buttonColor: primary300_main,
    textSelectionColor: primary500_light_text,
    errorColor: warning,

    textTheme: _buildTextTheme(base.textTheme),
  );
}

TextTheme _buildTextTheme(TextTheme base) {
  return base
      .copyWith(
    caption:
    TextStyle(fontSize: 12, color: Color(0xFFC4C4C4), letterSpacing: 0),
    overline:
    TextStyle(fontSize: 10, color: Color(0xFFC4C4C4), letterSpacing: 0),
    headline1: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.bold,
        color: Color(0xFF0D0D0D)),
    headline2: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Color(0xFF666666)),
    headline3: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: Color(0xFF666666)),
    headline4: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Color(0xFF2C2C2C)),
    headline5: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Color(0xFF1F1F1F)), //0D0D0D
    headline6: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF1F1F1F)),

    subtitle1: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF1F1F1F)),
    subtitle2: TextStyle(
        fontSize: 12, fontWeight: FontWeight.w500, color: gray900),

    bodyText1: TextStyle(
        fontSize: 16, fontWeight: FontWeight.w400, color: gray500),
    bodyText2: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF666666)),
  )
      .apply(
    fontFamily: 'NotoSansKR',
    displayColor: black87,
  );
}
