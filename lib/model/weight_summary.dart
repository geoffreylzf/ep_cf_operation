import 'package:ep_cf_operation/model/table/cf_weight_detail.dart';

class WeightSummary {
  int maleTtlQty = 0,
      femaleTtlQty = 0;
  double maleTtlWgt = 0,
      femaleTtlWgt = 0;
  double maleAvgWgt = 0,
      femaleAvgWgt = 0;

  WeightSummary(List<CfWeightDetail> detailList) {
    for (final dt in detailList) {
      if (dt.gender == "M"){
        maleTtlQty += dt.qty;
        maleTtlWgt += dt.weight;
      }
      if (dt.gender == "F"){
        femaleTtlQty += dt.qty;
        femaleTtlWgt += dt.weight;
      }
    }
    if (maleTtlQty > 0){
      maleAvgWgt = maleTtlWgt / maleTtlQty;
    }

    if (femaleTtlQty > 0){
      femaleAvgWgt = femaleTtlWgt / femaleTtlQty;
    }
  }
}
