class WeighingSchedule {
  int id, locationId, houseNo, day;
  String weighingDate;

  WeighingSchedule({
    this.id,
    this.locationId,
    this.houseNo,
    this.day,
    this.weighingDate,
  });

  factory WeighingSchedule.fromJson(Map<String, dynamic> json) => WeighingSchedule(
        id: json["id"],
        locationId: json["location_id"],
        houseNo: json["house_no"],
        day: json["day"],
        weighingDate: json["weighing_date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "location_id": locationId,
        "house_no": houseNo,
        "day": day,
        "weighing_date": weighingDate,
      };
}
