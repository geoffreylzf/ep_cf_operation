import 'dart:convert';

import 'package:ep_cf_operation/model/api_response.dart';
import 'package:ep_cf_operation/model/auth.dart';
import 'package:ep_cf_operation/model/table/branch.dart';
import 'package:ep_cf_operation/model/table/cf_feed_consumption.dart';
import 'package:ep_cf_operation/model/table/cf_feed_in.dart';
import 'package:ep_cf_operation/model/table/cf_mortality.dart';
import 'package:ep_cf_operation/model/table/cf_weight.dart';
import 'package:ep_cf_operation/model/table/feed.dart';
import 'package:ep_cf_operation/model/table/weighing_schedule.dart';
import 'package:ep_cf_operation/model/upload_body.dart';
import 'package:ep_cf_operation/model/upload_result.dart';
import 'package:ep_cf_operation/model/user.dart';
import 'package:ep_cf_operation/module/shares_preferences_module.dart';
import 'package:http/http.dart' as http;

class ApiModule {
  static final _instance = ApiModule._internal();

  factory ApiModule() => _instance;

  ApiModule._internal();

  static const _globalUrl = "http://epgroup.dyndns.org:8833/eperp/index.php?r=";
  static const _localUrl = "http://192.168.8.1:8833/eperp/index.php?r=";

  static const _loginModule = "apiMobileAuth/nonGoogleAccLogin";
  static const _housekeepingModule = "apiMobileCfOperation/getHouseKeeping";
  static const _uploadModule = "apiMobileCfOperation/upload";
  static const _historyModule = "apiMobileCfOperation/getHistory";
  static const _weighingScheduleModule = "apiMobileCfOperation/getWeighingSchedule";

  Future<String> constructUrl(String module) async {
    final isLocal = await SharedPreferencesModule().getLocalCheck() ?? false;
    if (isLocal) {
      return _localUrl + module;
    }
    return _globalUrl + module;
  }

  String validateResponse(http.Response response) {
    if (response.statusCode == 200) {
      return response.body;
    }
    throw Exception('Connection Failed');
  }

  Future<ApiResponse<Auth>> login(String username, String password) async {
    String basicAuth = User(username, password).getCredential();

    final response = await http.post(
      await constructUrl(_loginModule),
      headers: {'authorization': basicAuth},
    );

    return ApiResponse.fromJson(jsonDecode(validateResponse(response)));
  }

  Future<ApiResponse<List<Branch>>> getBranch() async {
    final user = await SharedPreferencesModule().getUser();
    String basicAuth = user.getCredential();

    final response = await http.get(
      await constructUrl(_housekeepingModule) + "&type=branch",
      headers: {'authorization': basicAuth},
    );
    return ApiResponse.fromJson(jsonDecode(validateResponse(response)));
  }

  Future<ApiResponse<List<WeighingSchedule>>> getWeighingSchedule(int locationId) async {
    final user = await SharedPreferencesModule().getUser();
    String basicAuth = user.getCredential();

    final response = await http.get(
      await constructUrl(_weighingScheduleModule) + "&location_id=$locationId",
      headers: {'authorization': basicAuth},
    );
    return ApiResponse.fromJson(jsonDecode(validateResponse(response)));
  }

  Future<ApiResponse<List<Feed>>> getFeed() async {
    final user = await SharedPreferencesModule().getUser();
    String basicAuth = user.getCredential();

    final response = await http.get(
      await constructUrl(_housekeepingModule) + "&type=feed",
      headers: {'authorization': basicAuth},
    );
    return ApiResponse.fromJson(jsonDecode(validateResponse(response)));
  }

  Future<ApiResponse<List<CfMortality>>> getCfMortalityList(
    int companyId,
    int locationId,
    int batch,
  ) async {
    final user = await SharedPreferencesModule().getUser();
    String basicAuth = user.getCredential();

    final response = await http.get(
      await constructUrl(_historyModule) +
          "&type=mortality" +
          "&company_id=$companyId" +
          "&location_id=$locationId" +
          "&batch=$batch",
      headers: {'authorization': basicAuth},
    );
    return ApiResponse.fromJson(jsonDecode(validateResponse(response)));
  }

  Future<ApiResponse<List<CfWeight>>> getCfWeightList(
    int companyId,
    int locationId,
    int batch,
  ) async {
    final user = await SharedPreferencesModule().getUser();
    String basicAuth = user.getCredential();

    final response = await http.get(
      await constructUrl(_historyModule) +
          "&type=weight" +
          "&company_id=$companyId" +
          "&location_id=$locationId" +
          "&batch=$batch",
      headers: {'authorization': basicAuth},
    );
    return ApiResponse.fromJson(jsonDecode(validateResponse(response)));
  }

  Future<ApiResponse<UploadResult>> upload(UploadBody uploadBody) async {
    final user = await SharedPreferencesModule().getUser();
    String basicAuth = user.getCredential();

    final response = await http.post(
      await constructUrl(_uploadModule),
      headers: {
        'authorization': basicAuth,
        "Content-Type": "application/json",
      },
      body: jsonEncode(uploadBody.toJson()),
    );

    return ApiResponse.fromJson(jsonDecode(validateResponse(response)));
  }

  Future<ApiResponse<List<CfFeedIn>>> getCfFeedInList(
    int companyId,
    int locationId,
    int batch,
  ) async {
    final user = await SharedPreferencesModule().getUser();
    String basicAuth = user.getCredential();

    final response = await http.get(
      await constructUrl(_historyModule) +
          "&type=feedIn" +
          "&company_id=$companyId" +
          "&location_id=$locationId" +
          "&batch=$batch",
      headers: {'authorization': basicAuth},
    );
    return ApiResponse.fromJson(jsonDecode(validateResponse(response)));
  }

  Future<ApiResponse<List<CfFeedConsumption>>> getCfFeedConsumptionList(
    int companyId,
    int locationId,
    int batch,
  ) async {
    final user = await SharedPreferencesModule().getUser();
    String basicAuth = user.getCredential();

    final response = await http.get(
      await constructUrl(_historyModule) +
          "&type=feedConsumption" +
          "&company_id=$companyId" +
          "&location_id=$locationId" +
          "&batch=$batch",
      headers: {'authorization': basicAuth},
    );
    return ApiResponse.fromJson(jsonDecode(validateResponse(response)));
  }
}
