import 'dart:async';

import 'package:ep_cf_operation/model/feed_in_qr.dart';
import 'package:ep_cf_operation/res/string.dart';
import 'package:ep_cf_operation/screen/feed_in_detail/feed_in_detail_bloc.dart';
import 'package:ep_cf_operation/widget/display_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailEntry extends StatefulWidget {
  @override
  _DetailEntryState createState() => _DetailEntryState();
}

class _DetailEntryState extends State<DetailEntry> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Container(
                  color: Theme.of(context).highlightColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      Strings.feedItem,
                      style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                    ),
                  ),
                ),
              ),
              FeedItemSelection(),
              SizedBox(
                width: double.infinity,
                child: Container(
                  color: Theme.of(context).highlightColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      Strings.compartment,
                      style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                    ),
                  ),
                ),
              ),
              Expanded(child: CompartmentSelection()),
            ],
          ),
        ),
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                DataEntry(),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class FeedItemSelection extends StatefulWidget {
  @override
  _FeedItemSelectionState createState() => _FeedItemSelectionState();
}

class _FeedItemSelectionState extends State<FeedItemSelection> {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<FeedInDetailBloc>(context);
    return StreamBuilder<List<FeedData>>(
      stream: bloc.feedItemStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        final list = snapshot.data;
        return ListView.separated(
          shrinkWrap: true,
          itemCount: list.length,
          separatorBuilder: (ctx, index) => Divider(height: 0),
          itemBuilder: (ctx, position) {
            final feedItem = list[position];
            return StreamBuilder<FeedData>(
              stream: bloc.selectedFeedIDataStream,
              builder: (context, snapshot) {
                var bgColor = Theme.of(ctx).scaffoldBackgroundColor;
                var isSelected = false;

                if (snapshot.data == feedItem) {
                  bgColor = Theme.of(ctx).primaryColorLight;
                  isSelected = true;
                }

                return Container(
                  color: bgColor,
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.only(left: 16),
                    title: Text(feedItem.skuName),
                    subtitle: Text("${feedItem.remaining.toStringAsFixed(2)} ${feedItem.itemOumCode}"),
                    onTap: () {
                      bloc.setFeedItem(feedItem);
                    },
                    trailing: Checkbox(
                      value: isSelected,
                      onChanged: (b) {
                        bloc.setFeedItem(feedItem);
                      },
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class CompartmentSelection extends StatefulWidget {
  @override
  _CompartmentSelectionState createState() => _CompartmentSelectionState();
}

class _CompartmentSelectionState extends State<CompartmentSelection> {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<FeedInDetailBloc>(context);
    return StreamBuilder<List<CompartmentData>>(
      stream: bloc.compartmentListStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Center(
                child: Text(
              "Please select feed first",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            )),
          );
        }
        final list = snapshot.data;

        if (list.length == 0) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Center(
                child: Text(
              "No compartment for selected feed",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            )),
          );
        }

        return ListView.separated(
          itemCount: list.length,
          separatorBuilder: (ctx, index) => Divider(height: 0),
          itemBuilder: (ctx, position) {
            final compartment = list[position];
            return StreamBuilder<CompartmentData>(
              stream: bloc.selectedCompartmentStream,
              builder: (context, snapshot) {
                var bgColor = Theme.of(ctx).scaffoldBackgroundColor;
                var isSelected = false;

                if (snapshot.data == compartment) {
                  bgColor = Theme.of(ctx).primaryColorLight;
                  isSelected = true;
                }

                return Container(
                  color: bgColor,
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.only(left: 16),
                    title: Text(compartment.compartmentNo),
                    subtitle: Text(
                        "${compartment.remaining.toStringAsFixed(2)} ${bloc.getSelectedFeedData()?.itemOumCode}"),
                    onTap: () {
                      bloc.setCompartment(compartment);
                    },
                    trailing: Checkbox(
                      value: isSelected,
                      onChanged: (b) {
                        bloc.setCompartment(compartment);
                      },
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class DataEntry extends StatefulWidget {
  @override
  _DataEntryState createState() => _DataEntryState();
}

class _DataEntryState extends State<DataEntry> {
  final houseTec = TextEditingController();
  final qtyTec = TextEditingController();

  @override
  void initState() {
    super.initState();
    houseTec.text = "1";
    Future.delayed(Duration.zero, () {
      final bloc = Provider.of<FeedInDetailBloc>(context);
      bloc.qtyStream.listen((qty) {
        var v = "";
        if (qty != null) {
          v = qty.toString();
        }
        qtyTec.text = v;
      });

      qtyTec.addListener(() {
        bloc.setQty(double.tryParse(qtyTec.text));
      });
    });
  }

  @override
  void dispose() {
    //houseTec.dispose();
    //qtyTec.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<FeedInDetailBloc>(context);
    return Column(
      children: [
        TextField(
          controller: houseTec,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: Strings.houseNo,
            prefixIcon: Icon(Icons.home),
            contentPadding: EdgeInsets.all(16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Container(
            width: double.infinity,
            color: Theme.of(context).highlightColor,
            padding: EdgeInsets.all(8),
            child: Center(
              child: StreamBuilder<FeedData>(
                  stream: bloc.selectedFeedIDataStream,
                  builder: (context, snapshot) {
                    var uomCode = "MT";
                    var stdWeight = 1000.0;
                    if (snapshot.hasData) {
                      uomCode = snapshot.data.itemOumCode;
                      stdWeight = snapshot.data.stdWeight;
                    }
                    return Text("1 $uomCode = $stdWeight KG",
                        style: TextStyle(fontSize: 12, color: Colors.blueGrey));
                  }),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: StreamBuilder<double>(
              stream: bloc.weightStream,
              builder: (context, snapshot) {
                var weight = 0.0;
                if (snapshot.hasData) {
                  weight = snapshot.data;
                }
                return DisplayField(
                  title: Strings.weightKg,
                  value: weight.toString(),
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: TextField(
            controller: qtyTec,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: Strings.quantity,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SizedBox(
            width: double.infinity,
            child: RaisedButton.icon(
              icon: Icon(Icons.save),
              label: Text(Strings.insert.toUpperCase()),
              onPressed: () async {
                final houseNo = int.tryParse(houseTec.text);
                final qty = double.tryParse(qtyTec.text);

                final res = await bloc.insertDetail(houseNo, qty);
                if (res) {
                  qtyTec.text = "";
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
