class UploadResult {
  final List<PairId> cfMortalityPairIdList;
  final List<PairId> cfWeightPairIdList;

  UploadResult({this.cfMortalityPairIdList, this.cfWeightPairIdList});

  factory UploadResult.fromJson(Map<String, dynamic> json) => UploadResult(
        cfMortalityPairIdList:
            List<PairId>.from(json["cf_mortality_pair_id_list"].map((x) => PairId.fromJson(x))),
        cfWeightPairIdList:
            List<PairId>.from(json["cf_weight_pair_id_list"].map((x) => PairId.fromJson(x))),
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
