import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hire_mate/resources/widgets/custom_button.dart';
import 'package:hire_mate/view/user_screens/bottom_bar/bottom_navigation.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hire_mate/view_model/quiz_vm/quiz_vm.dart';

class QuizScreen extends StatefulWidget {
  final String selectedSkill;
  final String userId;

  const QuizScreen({
    super.key,
    required this.selectedSkill,
    required this.userId,
  });

  @override
  // ignore: library_private_types_in_public_api
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  Timer? _timer;
  int timeLeft = 60;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() => timeLeft--);
      } else {
        final viewModel = Provider.of<QuizViewModel>(context, listen: false);
        _submitQuiz(viewModel);
      }
    });
  }

  void _submitQuiz(QuizViewModel viewModel) {
    _timer?.cancel();
    int correctAnswers = viewModel.calculateCorrectAnswers();
    int wrongAnswers = viewModel.questions.length - correctAnswers;
    _saveResultsToFirestore(correctAnswers, wrongAnswers);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuizViewModel()..fetchQuestions(widget.selectedSkill),
      child: Consumer<QuizViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Quiz"),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Chip(
                    backgroundColor: timeLeft < 30 ? Colors.red : Colors.green,
                    label: Text('$timeLeft s',
                        style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            body: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : viewModel.questions.isEmpty
                    ? const Center(
                        child: Text(
                          'No questions found.',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: viewModel.questions.length,
                              itemBuilder: (context, index) {
                                final question = viewModel.questions[index];

                                // Null Safety Check for question
                                final questionText = question.question ??
                                    "No question available";
                                final answers =
                                    question.answers?.toJson() ?? {};

                                // Get exactly 4 options
                                final options =
                                    answers.entries.take(4).toList();

                                return Card(
                                  margin: const EdgeInsets.all(10),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Q${index + 1}: $questionText',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 15),
                                        if (options.isNotEmpty)
                                          ...options.map((entry) {
                                            final answerKey = entry.key;
                                            final answerText =
                                                entry.value ?? "No Answer";

                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      viewModel.selectedAnswers[
                                                                  index] ==
                                                              answerKey
                                                          ? Colors.deepPurple
                                                          : Colors.grey[300],
                                                  foregroundColor:
                                                      viewModel.selectedAnswers[
                                                                  index] ==
                                                              answerKey
                                                          ? Colors.white
                                                          : Colors.black,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  viewModel.selectAnswer(
                                                      index, answerKey);
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  child: Text(answerText,
                                                      textAlign:
                                                          TextAlign.center),
                                                ),
                                              ),
                                            );
                                          }),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: CustomButton(
                              color: Colors.deepPurple,
                              onTap: () => _submitQuiz(viewModel),
                              text: "Submit Quiz",
                            ),
                          ),
                        ],
                      ),
          );
        },
      ),
    );
  }

  Future<void> _saveResultsToFirestore(int correct, int wrong) async {
    if (widget.userId.isEmpty || widget.selectedSkill.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: User ID or Skill is missing')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update({
        'correctanswer': FieldValue.arrayUnion([correct]),
        'skills': FieldValue.arrayUnion([widget.selectedSkill]),
        'wronganswer': FieldValue.increment(wrong),
      });
      _showResultDialog(correct, wrong);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving results: $e')),
      );
    }
  }

  void _showResultDialog(int correct, int wrong) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Result'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Correct Answers: $correct',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Wrong Answers: $wrong',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CustomBottomBar()));
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
