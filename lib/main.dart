import 'package:ep_cf_operation/model/table/cf_weight.dart';
import 'package:ep_cf_operation/screen/company/company_screen.dart';
import 'package:ep_cf_operation/screen/home/home_screen.dart';
import 'package:ep_cf_operation/screen/housekeeping/housekeeping_screen.dart';
import 'package:ep_cf_operation/screen/location/location_screen.dart';
import 'package:ep_cf_operation/screen/login/login_screen.dart';
import 'package:ep_cf_operation/screen/mortality/mortality_screen.dart';
import 'package:ep_cf_operation/screen/mortality_history/mortality_history_screen.dart';
import 'package:ep_cf_operation/screen/settings/settings_screen.dart';
import 'package:ep_cf_operation/screen/splash/splash_screen.dart';
import 'package:ep_cf_operation/screen/upload/upload_screen.dart';
import 'package:ep_cf_operation/screen/weight/weight_screen.dart';
import 'package:ep_cf_operation/screen/weight_detail/weight_detail_screen.dart';
import 'package:ep_cf_operation/screen/weight_history/weight_history_screen.dart';
import 'package:ep_cf_operation/screen/weight_view/weight_view_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contract Farmer Operation',
      theme: ThemeData(
        primaryColor: Colors.orange[800],
        primaryColorDark: Colors.orange[900],
        accentColor: Colors.red,
        primarySwatch: Colors.red,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.orange[800],
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      routes: {
        "/": (ctx) => SplashScreen(),
        LoginScreen.route: (ctx) => LoginScreen(),
        HomeScreen.route: (ctx) => HomeScreen(),
        HousekeepingScreen.route: (ctx) => HousekeepingScreen(),
        UploadScreen.route: (ctx) => UploadScreen(),
        SettingsScreen.route: (ctx) => SettingsScreen(),
        CompanyScreen.route: (ctx) => CompanyScreen(),
        LocationScreen.route: (ctx) {
          final companyId = ModalRoute.of(ctx).settings.arguments as int;
          return LocationScreen(companyId);
        },
        MortalityScreen.route: (ctx) => MortalityScreen(),
        MortalityHistoryScreen.route: (ctx) => MortalityHistoryScreen(),
        WeightScreen.route: (ctx) => WeightScreen(),
        WeightDetailScreen.route: (ctx) {
          final cfWeight = ModalRoute.of(ctx).settings.arguments as CfWeight;
          return WeightDetailScreen(cfWeight);
        },
        WeightHistoryScreen.route: (ctx) => WeightHistoryScreen(),
        WeightViewScreen.route: (ctx) {
          final cfWeightId = ModalRoute.of(ctx).settings.arguments as int;
          return WeightViewScreen(cfWeightId);
        },
      },
    );
  }
}
