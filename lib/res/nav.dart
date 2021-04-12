import 'package:ep_cf_operation/model/user.dart';
import 'package:ep_cf_operation/module/shares_preferences_module.dart';
import 'package:ep_cf_operation/res/string.dart';
import 'package:ep_cf_operation/screen/company/company_screen.dart';
import 'package:ep_cf_operation/screen/housekeeping/housekeeping_screen.dart';
import 'package:ep_cf_operation/screen/login/login_screen.dart';
import 'package:ep_cf_operation/screen/settings/settings_screen.dart';
import 'package:ep_cf_operation/screen/update_app_ver/update_app_ver_screen.dart';
import 'package:ep_cf_operation/widget/simple_confirm_dialog.dart';
import 'package:flutter/material.dart';

class NavDrawerStart extends StatelessWidget {
  @override
  Widget build(BuildContext mainContext) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: FutureBuilder<User>(
                future: SharedPreferencesModule().getUser(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            snapshot.data.username,
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    );
                  }
                  return Container();
                }),
            decoration: BoxDecoration(
              color: Theme.of(mainContext).primaryColor,
            ),
          ),
          ListTile(
            dense: true,
            leading: Icon(Icons.place),
            title: Text(Strings.location),
            onTap: () {
              Navigator.pop(mainContext);
              Navigator.pushNamed(mainContext, CompanyScreen.route);
            },
          ),
          ListTile(
            dense: true,
            leading: Icon(Icons.view_quilt),
            title: Text(Strings.housekeeping),
            onTap: () {
              Navigator.pop(mainContext);
              Navigator.pushNamed(mainContext, HousekeepingScreen.route);
            },
          ),
          Divider(height: 0),
          ListTile(
            dense: true,
            leading: Icon(Icons.settings),
            title: Text(Strings.settings),
            onTap: () {
              Navigator.pop(mainContext);
              Navigator.pushNamed(mainContext, SettingsScreen.route);
            },
          ),
          Divider(height: 0),
          ListTile(
            leading: Icon(Icons.update),
            title: Text("Update App Version"),
            onTap: () {
              Navigator.pop(mainContext);
              Navigator.pushNamed(mainContext, UpdateAppVerScreen.route);
            },
          ),
          Divider(height: 0),
          ListTile(
            dense: true,
            leading: Icon(Icons.exit_to_app),
            title: Text(Strings.logout),
            onTap: () async {
              showDialog(
                  context: mainContext,
                  builder: (BuildContext context) {
                    return SimpleConfirmDialog(
                      title: "Logout?",
                      message: "Connection is needed for login after logout.",
                      btnPositiveText: Strings.logout,
                      vcb: () async {
                        await SharedPreferencesModule().clearUser();
                        Navigator.pushReplacementNamed(mainContext, LoginScreen.route);
                      },
                    );
                  });
            },
          ),
        ],
      ),
    );
  }
}
