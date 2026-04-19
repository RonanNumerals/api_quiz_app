import 'package:html_unescape/html_unescape.dart';

class Question {
  String question;
  String correctAnswer;
  List<String> answers;

  Question({required this.question, required this.correctAnswer, required this.answers});

  factory Question.fromJson(Map<String, dynamic> json) {
    final unescape = HtmlUnescape();

    List<String> allAnswers = List<String>.from(json['incorrect_answers']);
    allAnswers.add(json['correct_answer']);
    allAnswers.shuffle();

    allAnswers = allAnswers.map((a) => unescape.convert(a)).toList();
    allAnswers.shuffle();

    return Question(
      question: unescape.convert(json['question']),
      correctAnswer: unescape.convert(json['correct_answer']),
      answers: allAnswers,
    );
  }
}