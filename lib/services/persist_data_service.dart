import 'package:amazing_todo_list/interfaces/persist_data_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersistDataService implements IPersistData {
  @override
  Future delete(String key) async {
    var localStorage = await SharedPreferences.getInstance();
    localStorage.remove(key);
  }

  @override
  Future get(String key) async {
    var localStorage = await SharedPreferences.getInstance();
    return localStorage.get(key);
  }

  @override
  Future put(String key, value) async {
    var localStorage = await SharedPreferences.getInstance();
    if (value is String) {
      localStorage.setString(key, value);
    } else if (value is bool) {
      localStorage.setBool(key, value);
    } else if (value is double) {
      localStorage.setDouble(key, value);
    } else if (value is int) {
      localStorage.setInt(key, value);
    }
  }
}
