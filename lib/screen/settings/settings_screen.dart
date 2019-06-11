import 'package:ep_cf_operation/bloc/local_bloc.dart';
import 'package:ep_cf_operation/res/string.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  static const String route = '/settings';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LocalBloc>(
          builder: (_) => LocalBloc(),
          dispose: (_, value) => value.dispose(),
        )
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(Strings.settings),
        ),
        body: ListView(
          children: [
            LocalTitle(),
            Divider(height: 0),
            VersionTile(),
          ],
        ),
      ),
    );
  }
}

class VersionTile extends StatefulWidget {
  @override
  _VersionTileState createState() => _VersionTileState();
}

class _VersionTileState extends State<VersionTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(Strings.applicationVersion),
      subtitle: FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (ctx, snapshot) {
          var version = "";
          if (snapshot.hasData) {
            version = snapshot.data.version;
          }
          return Text(version);
        },
      ),
    );
  }
}

class LocalTitle extends StatefulWidget {
  @override
  _LocalTitleState createState() => _LocalTitleState();
}

class _LocalTitleState extends State<LocalTitle> {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<LocalBloc>(context);
    return ListTile(
      dense: true,
      title: Text("Local Network"),
      subtitle: Text("Tick this when using EP Group Wi-Fi"),
      trailing: StreamBuilder<bool>(
          stream: bloc.localCheckedStream,
          initialData: false,
          builder: (context, snapshot) {
            return Switch(
              value: snapshot.data,
              onChanged: (bool b) {
                bloc.setLocalChecked(b);
              },
            );
          }),
    );
  }
}
