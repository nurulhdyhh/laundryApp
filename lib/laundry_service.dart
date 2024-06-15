import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutterdemo/laundryShop.dart';

class LaundryService {
  static Future<List<LaundryShop>> searchLaundries(String keyword) async {
    final response = await http.get(
      Uri.parse('http://localhost:8000/laundries/search?keyword=$keyword'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<LaundryShop> searchResults =
          data.map((dynamic item) => LaundryShop.fromJson(item)).toList();
      return searchResults;
    } else {
      throw Exception('Failed to load laundries');
    }
  }
}
