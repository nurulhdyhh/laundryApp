import 'package:http/http.dart' as http;
import 'dart:convert';
import 'laundryShop.dart';

class ApiService {
  final String baseUrl = "http://127.0.0.1:8000";

  Future<List<LaundryShop>> fetchLaundries({String? type}) async {
    final response = await http.get(Uri.parse('$baseUrl/?type=${type ?? ''}'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => LaundryShop.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load laundries');
    }
  }
}
