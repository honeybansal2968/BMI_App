import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:estore/model/book.dart';
import 'package:estore/constants.dart';

class BooksApi {
  static Future<List<Book>> getBooks(String query) async {
    SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    final url = Uri.parse('${BASE_URL}api/box/search');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List books = json.decode(response.body);
      return books.map((json) => Book.fromJson(json)).where((book) {
        final titleLower = book.name!.toLowerCase();
        final searchLower = query.toLowerCase();
        return titleLower.contains(searchLower);
      }).toList();
    } else {
      throw Exception();
    }
  }
}
