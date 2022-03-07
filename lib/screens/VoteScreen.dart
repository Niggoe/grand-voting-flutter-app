import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voting/models/QuestionScreenArguments.dart';
import 'package:voting/widgets/VotingAppBar.dart';

/** 
 * This is the screen where the user has to vote and enter his choice of answer
 */

class VoteScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => VoteScreenState();
}

class VoteScreenState extends State<VoteScreen> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as QuestionScreenArguments;
    final Stream<QuerySnapshot> _queryStream = FirebaseFirestore.instance
        .collection('answers')
        .where("questionID", isEqualTo: args.questionID)
        .snapshots();

    return Scaffold(
      appBar: VotingAppBar(
        appBar: AppBar(),
        title: Text(args.question),
        widgets: [],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _queryStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Snapshot has Error:  ${snapshot.error}");
            }
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return new Text('Not connected to the Stream or null');
              case ConnectionState.active:
                List<DocumentSnapshot> allAnswers;
                var totalAnswersCount = 0;
                if (snapshot.hasData) {
                  allAnswers = snapshot.data!.docs;
                  totalAnswersCount = allAnswers.length;
                  if (totalAnswersCount > 0) {
                    return GridView.builder(
                        gridDelegate:
                            new SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemCount: totalAnswersCount,
                        itemBuilder: (BuildContext context, int index) {
                          return Center(
                            child: Card(
                              child: InkWell(
                                splashColor: Colors.blue.withAlpha(30),
                                onTap: () {
                                  answerVotingQuestion(
                                      args.questionID,
                                      allAnswers[index].id,
                                      allAnswers[index]["text"]);
                                },
                                child: Container(
                                    child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                      ClipRect(
                                          child: Align(
                                              alignment: Alignment.topCenter,
                                              heightFactor: 1.0,
                                              child: Text(
                                                  allAnswers[index]["text"]))),
                                    ])),
                              ),
                            ),
                          );
                        });
                  }
                }
                return Center(
                    child: Column(
                  children: const <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 50.0),
                    ),
                    Text(
                      "Keine Antworten gefunden",
                    )
                  ],
                ));

              case ConnectionState.done:
                return const Text('Not connected to the Stream or null');
              default:
                return const Text('Not connected to the Stream or null');
            }
          }),
    );
  }

  void answerVotingQuestion(String questionID, String answerID, String answer) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Confirm'),
              content: Text('Are you sure? You voted for \n\n $answer'),
              actions: <Widget>[
                IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      String userID = FirebaseAuth.instance.currentUser!.uid;
                      var listUser = [userID];
                      FirebaseFirestore.instance
                          .collection('questions')
                          .doc(questionID)
                          .update(
                              {"userVoted": FieldValue.arrayUnion(listUser)});
                      print('Answer doc id: $answerID');
                      FirebaseFirestore.instance
                          .collection('answers')
                          .doc(answerID)
                          .update({"votes": FieldValue.increment(1)});
                      Navigator.popUntil(
                          context, ModalRoute.withName('showVotingScreen'));
                    })
              ],
            ));
  }
}
