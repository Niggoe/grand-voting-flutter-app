import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:voting/controller/Database.dart';
import 'package:voting/models/question.dart';

class QuestionController extends GetxController {
  createQuestion(String question, List<String> answers, String? id) {
    List<Answers> allAnswers = [];
    for (String s in answers) {
      Answers currentAnswer = Answers(answer: s, votings: 0);
      allAnswers.add(currentAnswer);
    }
    Question newQuestion =
        Question(question: question, answers: allAnswers, votingID: id);

    Database().createQuestion(newQuestion);
  }
}
