class Question {
  String question;
  String correctAnswer;
  List<String> answers;

  Question({required this.question, required this.correctAnswer, required this.answers});

  factory Question.fromJson(Map<String, dynamic> json) {
    List<String> allAnswers = List<String>.from(json['incorrect_answers']);
    allAnswers.add(json['correct_answer']);
    allAnswers.shuffle();

    return Question(
      question: json['question'],
      correctAnswer: json['correct_answer'],
      answers: allAnswers,
    );
  }
}