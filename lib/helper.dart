import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

/// https://www.youtube.com/watch?v=NEt_-Ebou2M&ab_channel=LX%27sCodingDiary

class HiveHelper {
  static final _adresseList = Hive.box("adresse_List");

  static List<Map<String, dynamic>> getAdresses() {
    var adresseList = _adresseList.keys.map((key) {
      var value = _adresseList.get(key);
      return {
        'key': key,
        'name': value['name'],
        'adresse': value['adresse'],
        'phone': value['phone'],
      };
    }).toList();
    return adresseList; // return a list of grocery item
  }

  //Add grocery list to Hive
  static Future<void> addItem(Map<String, dynamic> newItem) async {
    await _adresseList.add(newItem);  //add newitem to Hive
  }

  //Update olditem in Hive
  static Future<void> updateItem(
      int itemKey, Map<String, dynamic> oldItem) async {
    await _adresseList.put(itemKey, oldItem);  // We use put to Update
  }

  //Delete item in Hive
  static Future<void> deleteItem(int itemKey) async {
    await _adresseList.delete(itemKey);
  }
}
