import 'package:ep_cf_operation/model/user.dart';
import 'package:ep_cf_operation/res/key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesModule {
  static final _instance = SharedPreferencesModule._internal();

  factory SharedPreferencesModule() => _instance;

  SharedPreferencesModule._internal();

  static SharedPreferences _sp;

  Future<SharedPreferences> get sp async {
    if (_sp != null) return _sp;
    _sp = await SharedPreferences.getInstance();
    return _sp;
  }

  saveLocalCheck(bool b) async {
    final prefs = await sp;
    await prefs.setBool(Keys.localChecked, b);
  }

  Future<bool> getLocalCheck() async {
    final prefs = await sp;
    return prefs.getBool(Keys.localChecked);
  }

  saveCompanyId(int companyId) async {
    final prefs = await sp;
    await prefs.setInt(Keys.companyId, companyId);
  }

  Future<int> getCompanyId() async {
    final prefs = await sp;
    return prefs.getInt(Keys.companyId);
  }

  saveLocationId(int locationId) async {
    final prefs = await sp;
    await prefs.setInt(Keys.locationId, locationId);
  }

  Future<int> getLocationId() async {
    final prefs = await sp;
    return prefs.getInt(Keys.locationId);
  }

  saveUser(User user) async {
    final prefs = await sp;
    await prefs.setString(Keys.username, user.username);
    await prefs.setString(Keys.password, user.password);
  }

  Future<User> getUser() async {
    final prefs = await sp;
    final username = prefs.getString(Keys.username);
    final password = prefs.getString(Keys.password);

    if (username == null || password == null) {
      return null;
    }

    return User(username, password);
  }
  clearUser() async {
    final prefs = await sp;
    await prefs.setString(Keys.username, null);
    await prefs.setString(Keys.password, null);
  }
}
