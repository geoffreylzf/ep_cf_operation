class UploadResult {
  final List<PairId> cfMortalityPairIdList;
  final List<PairId> cfWeightPairIdList;
  final List<PairId> cfFeedInPairIdList;
  final List<PairId> cfFeedConsumptionPairIdList;

  UploadResult(
      {this.cfMortalityPairIdList,
      this.cfWeightPairIdList,
      this.cfFeedInPairIdList,
      this.cfFeedConsumptionPairIdList});

  factory UploadResult.fromJson(Map<String, dynamic> json) => UploadResult(
        cfMortalityPairIdList:
            List<PairId>.from(json["cf_mortality_pair_id_list"].map((x) => PairId.fromJson(x))),
        cfWeightPairIdList:
            List<PairId>.from(json["cf_weight_pair_id_list"].map((x) => PairId.fromJson(x))),
        cfFeedInPairIdList:
            List<PairId>.from(json["cf_feed_in_pair_id_list"].map((x) => PairId.fromJson(x))),
        cfFeedConsumptionPairIdList: List<PairId>.from(
            json["cf_feed_consumption_pair_id_list"].map((x) => PairId.fromJson(x))),
      );
}

class PairId {
  int id, sid;

  PairId({this.id, this.sid});

  factory PairId.fromJson(Map<String, dynamic> json) => PairId(
        id: json["id"],
        sid: json["sid"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sid": sid,
      };
}
