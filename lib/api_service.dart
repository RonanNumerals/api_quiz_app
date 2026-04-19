import 'dart:convert';
import 'package:api_quiz_app/question.dart';
import 'package:http/http.dart';

class ApiService {
  final String baseUrl = 'https://opentdb.com/api.php';

  Future<List<Question>> fetchQuestions({int amount = 10, String? category, String? difficulty, String? type}) async {
    final uri = Uri.parse(baseUrl).replace(queryParameters: {
      'amount': amount.toString(),
      'category': category ?? '',
      'difficulty': difficulty ?? '',
      'type': type ?? '',
    });

    final response = await get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];

      return results
          .map((q) => Question.fromJson(q))
          .toList();
    } else {
      throw Exception('Failed to load questions');
    }
  }
}