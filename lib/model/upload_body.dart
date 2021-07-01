import 'package:ep_cf_operation/model/table/cf_feed_consumption.dart';
import 'package:ep_cf_operation/model/table/cf_feed_in.dart';
import 'package:ep_cf_operation/model/table/cf_mortality.dart';
import 'package:ep_cf_operation/model/table/cf_weight.dart';

class UploadBody {
  List<CfMortality> cfMortalityList;
  List<CfWeight> cfWeightList;
  List<CfFeedIn> cfFeedInList;
  List<CfFeedConsumption> cfFeedConsumptionList;

  UploadBody(
      {this.cfMortalityList, this.cfWeightList, this.cfFeedInList, this.cfFeedConsumptionList});

  Map<String, dynamic> toJson() => {
        "cf_mortality_list": cfMortalityList != null && cfMortalityList.length > 0
            ? List<dynamic>.from(cfMortalityList.map((x) => x.toJson()))
            : [],
        "cf_weight_list": cfWeightList != null && cfWeightList.length > 0
            ? List<dynamic>.from(cfWeightList.map((x) => x.toJson()))
            : [],
        "cf_feed_in_list": cfFeedInList != null && cfFeedInList.length > 0
            ? List<dynamic>.from(cfFeedInList.map((x) => x.toJson()))
            : [],
        "cf_feed_consumption_list":
            cfFeedConsumptionList != null && cfFeedConsumptionList.length > 0
                ? List<dynamic>.from(cfFeedConsumptionList.map((x) => x.toJson()))
                : [],
      };
}
