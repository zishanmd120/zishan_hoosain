import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TableApiService extends GetConnect {
  Future<http.Response> fetchTableData() async {
    const url = 'https://budget-app-backend-8lel.onrender.com/table/interview';
    try {
      final response = await http.get(Uri.parse(url));
      return response;
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
