import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DataFetcher {
  String ML_API_URL = dotenv.env['ML_API_URL'] ?? 'YOUR_ML_API_URL_HERE';

  // Load the .env file if not already loaded
  Future<String?> fetchData() async {
    try {
      final response = await http.get(Uri.parse(ML_API_URL));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('Request failed with status: ${response.statusCode}.');
        return null;
      }
    } catch (e) {
      print('Error fetching data: $e');
      return null;
    }
  }

  Future<String?> sendDataToML(File imageFile) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(ML_API_URL));
      request.files.add(await http.MultipartFile.fromPath(
        'image', // This is the field name expected by your ML endpoint
        imageFile.path,
      ));

      var response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return responseBody;
      } else {
        print('Request failed with status: ${response.statusCode}. Response: $responseBody');
        return null;
      }
    } catch (e) {
      print('Error sending data to ML endpoint: $e');
      return null;
    }
  }
}