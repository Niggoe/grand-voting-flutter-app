class Question {
  String? question;
  List<Answers>? answers;
  String? votingID;

  Question({this.question, this.answers, this.votingID});
}

class Answers {
  String? answer;
  int? votings;

  Answers({this.answer, this.votings});

  Map<String, dynamic> toJson() {
    return {
      "answerString": answer,
      "votings": votings,
    };
  }
}
