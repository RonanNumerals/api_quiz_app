import '../question.dart';
import '../api_service.dart';
import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> _questions = <Question>[];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _answered = false;

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    final api = ApiService();
    final questions = await api.fetchQuestions();
    setState(() {
      _questions = questions;
    });
  }

  void _answerQuestion(String selectedAnswer) {
    if (_answered) return;

    final correct = _questions[_currentQuestionIndex].correctAnswer;

    setState(() {
      _answered = true;
      if (selectedAnswer == correct) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _answered = false;
      });
    } else {
      _showScoreDialog();
    }
  }

  void _showScoreDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Quiz Completed"),
        content: Text("Your score: $_score/${_questions.length}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _currentQuestionIndex = 0;
                _score = 0;
                _answered = false;
              });
            },
            child: Text("Restart"),
          ),
        ],
      ),
    );
  }

  Widget _answerButtons() {
    final question = _questions[_currentQuestionIndex];
    List<Widget> buttons = [];

    buttons.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Question ${_currentQuestionIndex + 1}/${_questions.length}",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          Text(
            question.question,
            style: const TextStyle(fontSize: 20),
          ),
          SizedBox(height: 18),
        ]
      )
    );

    for (var answer in question.answers) {
      Color? color;

      if (_answered) {
        if (answer == question.correctAnswer) {
          color = Colors.green;
        } else {
          color = Colors.red;
        }
      }

      buttons.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => _answerQuestion(answer),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
              ),
              child: Text(answer),
            ),
            SizedBox(height: 18),
          ]
        )
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: buttons,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz Game"),
      ),
      body: Column(
        children: [
          _questions.isEmpty
            ? Center(child: CircularProgressIndicator())
            : _answerButtons(),
          FloatingActionButton(
            onPressed:() {
              if (_answered) {
                _nextQuestion();
              }
            },
            child: Text("Next"),
          )
        ],
      )
    );
  }
}