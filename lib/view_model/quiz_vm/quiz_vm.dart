import 'package:flutter/material.dart';
import 'package:hire_mate/data/network/network_api_services.dart';
import 'package:hire_mate/model/api_model/api_resp_model.dart';
import 'package:hire_mate/resources/end_points/api_key.dart';

class QuizViewModel extends ChangeNotifier {
  List<ApiResponseModel> questions = [];
  Map<int, String> selectedAnswers = {};
  bool isLoading = false;

  final NetworkApiServices _apiServices = NetworkApiServices();

  Future<void> fetchQuestions(String skill) async {
    isLoading = true;
    notifyListeners();

    final url =
        'https://quizapi.io/api/v1/questions?apiKey=${ApiKey.apiKey}&limit=10&category=$skill&difficulty=easy';

    try {
      final response = await _apiServices.getGetApiResponse(url);
      questions = (response as List)
          .map((data) => ApiResponseModel.fromJson(data))
          .toList();
    } catch (e) {
      print('Error fetching questions: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void selectAnswer(int questionIndex, String answerKey) {
    selectedAnswers[questionIndex] = answerKey;
    notifyListeners();
  }

  int calculateCorrectAnswers() {
    int correctCount = 0;
    for (var i = 0; i < questions.length; i++) {
      final correctAnswers = questions[i].correctAnswers?.toJson();
      if (correctAnswers != null) {
        final correctAnswerKey = correctAnswers.entries
            .firstWhere((entry) => entry.value == "true",
                orElse: () => const MapEntry("", ""))
            .key
            .replaceFirst('_correct', '');

        if (selectedAnswers[i] == correctAnswerKey) {
          correctCount++;
        }
      }
    }
    return correctCount;
  }
}
