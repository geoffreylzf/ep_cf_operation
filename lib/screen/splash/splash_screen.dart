import 'package:ep_cf_operation/module/shares_preferences_module.dart';
import 'package:ep_cf_operation/screen/home/home_screen.dart';
import 'package:ep_cf_operation/screen/login/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    SharedPreferencesModule().getUser().then((user) {
      if (user != null) {
        Navigator.pushReplacementNamed(context, HomeScreen.route);
      } else {
        Navigator.pushReplacementNamed(context, LoginScreen.route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(color: Theme.of(context).primaryColor),
    );
  }
}
