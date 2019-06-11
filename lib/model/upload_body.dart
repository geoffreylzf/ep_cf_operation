import 'package:ep_cf_operation/model/table/cf_mortality.dart';
import 'package:ep_cf_operation/model/table/cf_weight.dart';

class UploadBody {
  List<CfMortality> cfMortalityList;
  List<CfWeight> cfWeightList;

  UploadBody({this.cfMortalityList, this.cfWeightList});

  Map<String, dynamic> toJson() => {
        "cf_mortality_list": cfMortalityList != null && cfMortalityList.length > 0
            ? List<dynamic>.from(cfMortalityList.map((x) => x.toJson()))
            : [],
        "cf_weight_list": cfWeightList != null && cfWeightList.length > 0
            ? List<dynamic>.from(cfWeightList.map((x) => x.toJson()))
            : [],
      };
}
