import 'package:flutter/material.dart';

class FeedInQr {
  static const String splitLine = "\n";
  static const String splitField = "|";
  static const String typeHead = "H";
  static const String typeDetail = "D";
  static const String typeCompartment = "C";

  final String qr;
  HeadData _headData;
  final List<DetailData> _detailDataList = [];

  HeadData get headData => _headData;

  List<DetailData> get detailDataList => _detailDataList;

  FeedInQr(this.qr) {
    final lineList = qr.split(splitLine);

    DetailData currentDetailData;

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
        currentDetailData = DetailData(
          docDetailId: int.parse(fieldList[1]),
          itemPackingId: int.parse(fieldList[2]),
          qty: double.parse(fieldList[3]),
          weight: double.parse(fieldList[4]),
          itemOumCode: fieldList[5],
          stdWeight: int.parse(fieldList[6]),
        );

        _detailDataList.add(currentDetailData);
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

    if(_detailDataList.length == 0){
      throw Exception("Invalid format (No detail row)");
    }
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

class DetailData {
  final int docDetailId, itemPackingId, stdWeight;
  final double qty, weight;
  final String itemOumCode;
  final List<CompartmentData> compartmentDataList = [];

  DetailData({
    @required this.docDetailId,
    @required this.itemPackingId,
    @required this.stdWeight,
    @required this.qty,
    @required this.weight,
    @required this.itemOumCode,
  });
}

class CompartmentData {
  final String compartmentNo;
  final double qty, weight;

  CompartmentData({
    @required this.compartmentNo,
    @required this.qty,
    @required this.weight,
  });
}
