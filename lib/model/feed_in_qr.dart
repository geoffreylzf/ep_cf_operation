import 'package:ep_cf_operation/db/dao/feed_dao.dart';
import 'package:ep_cf_operation/db/dao/temp_cf_feed_in_detail_dao.dart';
import 'package:flutter/material.dart';

class FeedInQr {
  static const String splitLine = "\n";
  static const String splitField = "|";
  static const String typeHead = "H";
  static const String typeDetail = "D";
  static const String typeCompartment = "C";

  final String qr;
  HeadData _headData;
  final List<FeedData> _feedDataList = [];

  HeadData get headData => _headData;

  List<FeedData> get feedDataList => _feedDataList;

  FeedInQr(this.qr) {
    final lineList = qr.split(splitLine);

    FeedData currentDetailData;

    for (final line in lineList) {
      final fieldList = line.split(splitField);

      final type = fieldList[0];

      if (type == typeHead) {
        if (_headData != null) {
          throw Exception("Invalid format (Have 2 head row)");
        }
        _headData = HeadData(
          docId: int.parse(fieldList[1]),
          docNo: fieldList[2],
          truckNo: fieldList[3],
        );
      }

      if (type == typeDetail) {
        currentDetailData = FeedData(
          docDetailId: int.parse(fieldList[1]),
          itemPackingId: int.parse(fieldList[2]),
          qty: double.parse(fieldList[3]),
          weight: double.parse(fieldList[4]),
          itemOumCode: fieldList[5],
          stdWeight: double.parse(fieldList[6]),
        );
        _feedDataList.add(currentDetailData);
      }

      if (type == typeCompartment) {
        if (currentDetailData == null) {
          throw Exception("Invalid format (Have compartment row before detail row)");
        }

        final compartmentData = CompartmentData(
          compartmentNo: fieldList[1],
          qty: double.parse(fieldList[2]),
          weight: double.parse(fieldList[3]),
        );
        currentDetailData.compartmentDataList.add(compartmentData);
      }
    }

    if (_headData == null) {
      throw Exception("Invalid format");
    }

    if (_feedDataList.length == 0) {
      throw Exception("Invalid format (No detail row)");
    }
  }

  loadFeedItemData() async {
    await Future.forEach<FeedData>(_feedDataList, (detail) async {
      final feed = await FeedDao().getById(detail.itemPackingId);
      if (feed != null) {
        debugPrint(feed.skuName);
        detail.skuName = feed.skuName;
        detail.skuCode = feed.skuCode;
      }
    });
  }

  loadRemaining() async {
    await Future.forEach<FeedData>(_feedDataList, (detail) async {
      final docDetailId = detail.docDetailId;
      final itemPackingId = detail.itemPackingId;

      final tempList = await TempCfFeedInDetailDao().searchList(
        docDetailId: docDetailId,
        itemPackingId: itemPackingId,
      );

      if (tempList.length != 0) {
        detail.usedQty = tempList.map((temp) => temp.qty).reduce((curr, next) => curr + next);
      } else {
        detail.usedQty = 0;
      }

      if (detail.compartmentDataList != null) {
        await Future.forEach<CompartmentData>(detail.compartmentDataList, (compartment) async {
          final compartmentNo = compartment.compartmentNo;

          final tempList2 = await TempCfFeedInDetailDao().searchList(
            docDetailId: docDetailId,
            itemPackingId: itemPackingId,
            compartmentNo: compartmentNo,
          );

          if (tempList2.length != 0) {
            compartment.usedQty =
                tempList2.map((temp) => temp.qty).reduce((curr, next) => curr + next);
          } else {
            compartment.usedQty = 0;
          }
        });
      }
    });
  }
}

class HeadData {
  final int docId;
  final String docNo, truckNo;

  HeadData({
    @required this.docId,
    @required this.docNo,
    @required this.truckNo,
  });
}

class FeedData {
  final int docDetailId, itemPackingId;
  final double qty, weight, stdWeight;
  final String itemOumCode;
  final List<CompartmentData> compartmentDataList = [];

  String skuCode;
  String skuName;
  double usedQty = 0;

  FeedData({
    @required this.docDetailId,
    @required this.itemPackingId,
    @required this.stdWeight,
    @required this.qty,
    @required this.weight,
    @required this.itemOumCode,
  }) {
    skuName = "New Item ($itemPackingId)";
  }

  double get remaining => qty - usedQty;
}

class CompartmentData {
  final String compartmentNo;
  final double qty, weight;

  double usedQty = 0;

  CompartmentData({
    @required this.compartmentNo,
    @required this.qty,
    @required this.weight,
  });

  double get remaining => qty - usedQty;
}
