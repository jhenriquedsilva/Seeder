import 'package:seed/models/user.dart';
import 'package:seed/preferences/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferencesService implements LocalStorageService{

  static const USER_ID = 'user_id';
  static const FULL_NAME = 'full_name';
  static const EMAIL = 'email';

  Future<SharedPreferences> _getInstance() {
    return SharedPreferences.getInstance();
  }

  @override
  Future<void> delete() async {
    final prefs = await _getInstance();
    prefs.clear();
  }

  @override
  Future<void> save(User user) async {
    final prefs = await _getInstance();
    prefs.setString(USER_ID, user.id);
    prefs.setString(FULL_NAME, user.fullName);
    prefs.setString(EMAIL, user.email);
  }

  @override
  Future<String?> getId() async {
    final prefs = await _getInstance();
    return prefs.getString(USER_ID);
  }

}