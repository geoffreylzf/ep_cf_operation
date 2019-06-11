import 'package:ep_cf_operation/model/table/branch.dart';
import 'package:ep_cf_operation/screen/location/location_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocationScreen extends StatefulWidget {
  static const String route = '/location';

  final int companyId;

  LocationScreen(this.companyId);

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Provider<LocationBloc>(
      builder: (_) => LocationBloc(companyId: widget.companyId),
      dispose: (_, value) => value.dispose(),
      child: Scaffold(
        appBar: AppBar(title: Text("Location Selection")),
        body: LocationList(),
      ),
    );
  }
}

class LocationList extends StatefulWidget {
  @override
  _LocationListState createState() => _LocationListState();
}

class _LocationListState extends State<LocationList> {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<LocationBloc>(context);
    return StreamBuilder<List<Branch>>(
      stream: bloc.locListStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        var list = snapshot.data;
        return ListView.separated(
          separatorBuilder: (ctx, index) => Divider(
                height: 0,
              ),
          itemCount: list.length,
          itemBuilder: (ctx, position) => ListTile(
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.place),
                ),
                title: Text(list[position].branchName),
                subtitle: Text(list[position].branchCode),
                onTap: () async {
                  await bloc.saveLocation(list[position].id);
                  Navigator.pop(context);
                },
              ),
        );
      },
    );
  }
}
