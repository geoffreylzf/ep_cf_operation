import 'package:ep_cf_operation/model/auth.dart';
import 'package:ep_cf_operation/model/table/branch.dart';
import 'package:ep_cf_operation/model/table/cf_feed_consumption.dart';
import 'package:ep_cf_operation/model/table/cf_feed_in.dart';
import 'package:ep_cf_operation/model/table/cf_mortality.dart';
import 'package:ep_cf_operation/model/table/cf_weight.dart';
import 'package:ep_cf_operation/model/table/feed.dart';
import 'package:ep_cf_operation/model/table/weighing_schedule.dart';
import 'package:ep_cf_operation/model/upload_result.dart';

class ApiResponse<T> {
  final int cod;
  final T result;

  ApiResponse({this.cod, this.result});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    var result;

    if (T == Auth) {
      result = Auth.fromJson(json['result']);
    } else if (T == UploadResult) {
      result = UploadResult.fromJson(json['result']);
    } else if (T.toString() == "List<Branch>") {
      result = List<Branch>.from(json["result"].map((x) => Branch.fromJson(x)));
    } else if (T.toString() == "List<Feed>") {
      result = List<Feed>.from(json["result"].map((x) => Feed.fromJson(x)));
    } else if (T.toString() == "List<CfMortality>") {
      result = List<CfMortality>.from(json["result"].map((x) => CfMortality.fromJson(x)));
    } else if (T.toString() == "List<CfWeight>") {
      result = List<CfWeight>.from(json["result"].map((x) => CfWeight.fromJson(x)));
    } else if (T.toString() == "List<CfFeedIn>") {
      result = List<CfFeedIn>.from(json["result"].map((x) => CfFeedIn.fromJson(x)));
    } else if (T.toString() == "List<CfFeedConsumption>") {
      result =
          List<CfFeedConsumption>.from(json["result"].map((x) => CfFeedConsumption.fromJson(x)));
    } else if (T.toString() == "List<WeighingSchedule>") {
      result = List<WeighingSchedule>.from(json["result"].map((x) => WeighingSchedule.fromJson(x)));
    }

    return ApiResponse(cod: json['cod'], result: result);
  }
}
