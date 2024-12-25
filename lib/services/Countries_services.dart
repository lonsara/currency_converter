import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert';
  class CountriesServices {
  // Replace 'YOUR_API_URL' with the actual URL of your API
  Future<Map<String, dynamic>> getdatafromAPI() async {
  final response = await http.get(Uri.parse('https://api.currencyapi.com/v3/latest?apikey=cur_live_NMVEfB9BHwupH6kVHkuEOwNc4QibLdyObmJh215E'));

  if (response.statusCode == 200) {
  // Decode the JSON response
  final Map<String, dynamic> data = json.decode(response.body);
  // Return the 'data' part of the response
  return data['data'];
  } else {
  throw Exception('Failed to load currencies');
  }
  }
  }
